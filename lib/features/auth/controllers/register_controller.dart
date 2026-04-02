import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:school_assgn/core/auth/google_auth_service.dart';
import 'package:school_assgn/core/firebase/firebase_initializer.dart';
import 'package:school_assgn/core/network/api_exception.dart';
import 'package:school_assgn/core/session/session_service.dart';
import 'package:school_assgn/features/auth/services/auth_api_service.dart';
import 'package:school_assgn/routes/app_routes.dart';

class RegisterController extends GetxController {
  RegisterController(this._authApiService);

  final AuthApiService _authApiService;

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController firstnameLcController = TextEditingController();
  final TextEditingController lastnameLcController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isSubmitting = false.obs;

  Future<void> register() async {
    final firstname = firstnameController.text.trim();
    final lastname = lastnameController.text.trim();
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final phoneNumber = phoneNumberController.text.trim();
    final password = passwordController.text.trim();

    if (firstname.isEmpty ||
        lastname.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty) {
      Get.snackbar('Missing fields', 'Please fill all required fields.');
      return;
    }

    final firstnameLc = _toNullable(firstnameLcController.text);
    final lastnameLc = _toNullable(lastnameLcController.text);
    isSubmitting.value = true;
    try {
      await _authApiService.register(
        firstname: firstname,
        lastname: lastname,
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        firstnameLc: firstnameLc,
        lastnameLc: lastnameLc,
      );
      unawaited(
        _syncFirebaseEmailPasswordAccount(email: email, password: password),
      );

      Get.snackbar('Success', 'Account created successfully.');
      Get.offNamed(AppRoutes.signIn);
    } on ApiException catch (error) {
      Get.snackbar('Register failed', error.message);
    } catch (error) {
      Get.snackbar('Register failed', 'Unexpected error: $error');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> registerWithGoogle() async {
    if (isSubmitting.value) {
      return;
    }

    isSubmitting.value = true;
    final googleAuthService = Get.find<GoogleAuthService>();
    GoogleAuthResult? googleResult;
    String googleEmail = '';
    String googleDisplayFallback = 'Google User';
    try {
      googleResult = await googleAuthService.signIn();
      if (googleResult == null) {
        return;
      }

      googleEmail = (googleResult.email ?? '').trim();
      if (googleEmail.isEmpty) {
        Get.snackbar(
          'Google Sign-In Failed',
          'Google account email is missing. Please try another account.',
        );
        return;
      }

      googleDisplayFallback = _resolveGoogleDisplayName(
        googleResult.displayName,
        googleEmail,
      );

      final backendResponse = await _tryGoogleBackendLogin(
        firebaseUid: googleResult.firebaseUid,
        email: googleEmail,
        displayName: googleResult.displayName,
      );

      if (backendResponse == null) {
        await _completeGoogleFirebaseLogin(
          googleResult,
          fallbackDisplayName: googleDisplayFallback,
        );
      } else {
        await _completeGoogleBackendLogin(
          backendResponse,
          fallbackDisplayName: googleDisplayFallback,
        );
      }
    } on GoogleAuthException catch (error) {
      Get.snackbar('Google Sign-In Failed', error.message);
    } on ApiException catch (error) {
      final canFallbackToGoogleSession =
          googleResult != null &&
          googleEmail.isNotEmpty &&
          _needsExistingPasswordForGoogleSync(error);

      if (canFallbackToGoogleSession) {
        await _completeGoogleFirebaseLogin(
          googleResult,
          fallbackDisplayName: googleDisplayFallback,
        );
        return;
      }

      Get.snackbar('Google Sign-In Failed', error.message);
    } on FirebaseAuthException catch (error) {
      Get.snackbar(
        'Google Sign-In Failed',
        error.message ?? 'Please try again.',
      );
    } on FirebaseException catch (error) {
      if (error.code == 'no-app') {
        Get.snackbar(
          'Google Sign-In Failed',
          'Firebase is not ready. Please restart the app and try again.',
        );
      } else {
        Get.snackbar(
          'Google Sign-In Failed',
          error.message ?? 'Please try again.',
        );
      }
    } catch (error) {
      Get.snackbar('Google Sign-In Failed', 'Unexpected error: $error');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _completeGoogleBackendLogin(
    Map<String, dynamic> backendResponse, {
    required String fallbackDisplayName,
  }) async {
    final accessToken =
        backendResponse['access_token']?.toString().trim() ?? '';
    if (accessToken.isEmpty) {
      throw ApiException(message: 'Invalid backend login response.');
    }

    final backendUser = backendResponse['user'];
    final displayName = _resolveDisplayName(
      backendUser,
      fallback: fallbackDisplayName,
    );
    final userId = backendUser is Map
        ? (backendUser['id']?.toString() ?? '')
        : '';

    final sessionService = Get.find<SessionService>();
    await sessionService.saveSession(
      accessToken: accessToken,
      userName: displayName,
      userId: userId,
    );

    Get.offAllNamed(AppRoutes.mainNav, arguments: {'welcomeName': displayName});
  }

  Future<Map<String, dynamic>?> _tryGoogleBackendLogin({
    required String firebaseUid,
    required String email,
    String? displayName,
  }) async {
    try {
      return await _authApiService
          .ensureGoogleUserInBackendAndLogin(
            firebaseUid: firebaseUid,
            email: email,
            displayName: displayName,
          )
          .timeout(const Duration(seconds: 8));
    } on TimeoutException {
      return null;
    }
  }

  Future<void> _completeGoogleFirebaseLogin(
    GoogleAuthResult googleResult, {
    required String fallbackDisplayName,
  }) async {
    final sessionService = Get.find<SessionService>();
    await sessionService.saveSession(
      accessToken: googleResult.sessionToken,
      userName: fallbackDisplayName,
    );

    Get.offAllNamed(
      AppRoutes.mainNav,
      arguments: {'welcomeName': fallbackDisplayName},
    );
  }

  bool _needsExistingPasswordForGoogleSync(ApiException error) {
    final message = error.message.toLowerCase();
    final looksLikeInvalidCredentials =
        message.contains('invalid email or password') ||
        message.contains('invalid credentials') ||
        message.contains('unauthorized');

    if (looksLikeInvalidCredentials && (error.statusCode == null)) {
      return true;
    }

    if (looksLikeInvalidCredentials &&
        (error.statusCode == 401 || error.statusCode == 400)) {
      return true;
    }

    return false;
  }

  String? _toNullable(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _resolveGoogleDisplayName(String? displayName, String? email) {
    final name = (displayName ?? '').trim();
    if (name.isNotEmpty) {
      return name;
    }

    final emailText = (email ?? '').trim();
    if (emailText.isNotEmpty) {
      return emailText.split('@').first;
    }

    return 'Google User';
  }

  String _resolveDisplayName(Object? user, {required String fallback}) {
    if (user is! Map<String, dynamic>) {
      return fallback;
    }

    final firstname = user['firstname']?.toString().trim() ?? '';
    if (firstname.isNotEmpty) {
      return firstname;
    }

    final username = user['username']?.toString().trim() ?? '';
    if (username.isNotEmpty) {
      return username;
    }

    return fallback;
  }

  Future<void> _syncFirebaseEmailPasswordAccount({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim();
    if (!GetUtils.isEmail(normalizedEmail) || password.length < 6) {
      return;
    }

    try {
      await ensureFirebaseInitialized();

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: normalizedEmail,
            password: password,
          )
          .timeout(const Duration(seconds: 8));
      await FirebaseAuth.instance.signOut().timeout(const Duration(seconds: 8));
    } on FirebaseAuthException catch (error) {
      if (error.code != 'email-already-in-use') {
        return;
      }

      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: normalizedEmail,
              password: password,
            )
            .timeout(const Duration(seconds: 8));
      } catch (_) {
        return;
      } finally {
        try {
          await FirebaseAuth.instance.signOut().timeout(
            const Duration(seconds: 8),
          );
        } catch (_) {}
      }
    } catch (_) {}
  }

  @override
  void onClose() {
    firstnameController.dispose();
    lastnameController.dispose();
    firstnameLcController.dispose();
    lastnameLcController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
