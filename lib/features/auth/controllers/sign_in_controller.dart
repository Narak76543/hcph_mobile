import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:school_assgn/core/auth/google_auth_service.dart';
import 'package:school_assgn/core/firebase/firebase_initializer.dart';
import 'package:school_assgn/core/network/api_exception.dart';
import 'package:school_assgn/core/session/session_service.dart';
import 'package:school_assgn/features/auth/services/auth_api_service.dart';
import 'package:school_assgn/routes/app_routes.dart';
import 'package:school_assgn/themes/app_color.dart';

class SignInController extends GetxController {
  SignInController(this._authApiService);

  final AuthApiService _authApiService;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool rememberMe = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool isEmailSubmitting = false.obs;
  final RxBool isGoogleSubmitting = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool isResetSending = false.obs;
  DateTime? _lastResetSentAt;

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void openForgotPasswordDialog() {
    final initialEmail = usernameController.text.trim();
    final dialogEmailController = TextEditingController(
      text: GetUtils.isEmail(initialEmail) ? initialEmail : '',
    );

    Get.dialog<void>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.alternate_email_rounded, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Enter your email to receive a password reset link.',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dialogEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 14),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: isResetSending.value
                        ? null
                        : () => submitForgotPassword(dialogEmailController.text),
                    child: isResetSending.value
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: LoadingAnimationWidget.discreteCircle(
                              color: AppColor.kGoogleBlue,
                              secondRingColor: AppColor.kGoogleRed,
                              thirdRingColor: AppColor.kGoogleYellow,
                              size: 22,
                            ),
                          )
                        : const Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    ).whenComplete(dialogEmailController.dispose);
  }

  Future<void> submitForgotPassword(String emailInput) async {
    if (isSubmitting.value || isResetSending.value) {
      return;
    }

    final now = DateTime.now();
    if (_lastResetSentAt != null &&
        now.difference(_lastResetSentAt!).inSeconds < 45) {
      Get.snackbar(
        'Please wait',
        'Use the latest reset email. You can request another link in a few seconds.',
      );
      return;
    }

    final email = emailInput.trim();
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar('Invalid email', 'Please enter a valid email address.');
      return;
    }

    try {
      isResetSending.value = true;
      await ensureFirebaseInitialized();

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _lastResetSentAt = DateTime.now();

      if (Get.isDialogOpen ?? false) {
        Get.back<void>();
      }
      _showResetSentDialog();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        Get.snackbar(
          'Reset unavailable',
          'This email is not linked to Firebase reset yet.',
        );
        return;
      }
      Get.snackbar(
        'Reset failed',
        error.message ?? 'Could not send reset email. Please try again.',
      );
    } on FirebaseException catch (error) {
      if (error.code == 'no-app') {
        Get.snackbar(
          'Reset unavailable',
          'Firebase is not ready. Please restart the app and try again.',
        );
        return;
      }
      Get.snackbar(
        'Reset failed',
        error.message ?? 'Could not send reset email. Please try again.',
      );
    } catch (error) {
      Get.snackbar('Reset failed', 'Unexpected error: $error');
    } finally {
      isResetSending.value = false;
    }
  }

  void _showResetSentDialog() {
    Get.dialog<void>(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFE9F2FF),
                child: Icon(
                  Icons.alternate_email_rounded,
                  color: Color(0xFF1F7BEE),
                  size: 26,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Reset Email Sent',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'we ahev sent you the email , please check your Box ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Get.back<void>(),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Future<void> signIn() async {
    if (isSubmitting.value) {
      return;
    }

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Missing fields', 'Please fill in username/email and password.');
      return;
    }

    isEmailSubmitting.value = true;
    isSubmitting.value = true;
    try {
      final response = await _authApiService.login(
        username: username,
        password: password,
      );
      final accessToken = response['access_token']?.toString().trim() ?? '';
      if (accessToken.isEmpty) {
        Get.snackbar('Login failed', 'Invalid login response from server.');
        return;
      }

      final user = response['user'];
      final displayName = _resolveDisplayName(user, fallback: username);
      final firebaseEmail = _extractEmail(user, fallback: username);
      unawaited(
        _syncFirebaseEmailPasswordAccount(
          email: firebaseEmail,
          password: password,
        ),
      );
      final sessionService = Get.find<SessionService>();
      await sessionService.saveSession(
        accessToken: accessToken,
        userName: displayName,
      );

      Get.offAllNamed(
        AppRoutes.mainNav,
        arguments: {'welcomeName': displayName},
      );
    } on ApiException catch (error) {
      Get.snackbar('Login failed', _buildLoginErrorMessage(error, username));
    } catch (error) {
      Get.snackbar('Login failed', 'Unexpected error: $error');
    } finally {
      isEmailSubmitting.value = false;
      isSubmitting.value = isGoogleSubmitting.value;
    }
  }

  Future<void> signInWithGoogle() async {
    if (isSubmitting.value) {
      return;
    }

    isGoogleSubmitting.value = true;
    isSubmitting.value = true;
    final googleAuthService = Get.find<GoogleAuthService>();
    GoogleAuthResult? googleResult;
    String googleEmail = '';
    String googleDisplayFallback = 'Google User';
    try {
      await ensureFirebaseInitialized();

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
          googleResult!,
          fallbackDisplayName: googleDisplayFallback,
        );
        return;
      }

      Get.snackbar('Google Sign-In Failed', error.message);
    } on FirebaseAuthException catch (error) {
      Get.snackbar('Google Sign-In Failed', error.message ?? 'Please try again.');
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
      isGoogleSubmitting.value = false;
      isSubmitting.value = isEmailSubmitting.value;
    }
  }

  Future<void> _completeGoogleBackendLogin(
    Map<String, dynamic> backendResponse, {
    required String fallbackDisplayName,
  }) async {
    final accessToken = backendResponse['access_token']?.toString().trim() ?? '';
    if (accessToken.isEmpty) {
      throw ApiException(message: 'Invalid backend login response.');
    }

    final backendUser = backendResponse['user'];
    final displayName = _resolveDisplayName(
      backendUser,
      fallback: fallbackDisplayName,
    );

    final sessionService = Get.find<SessionService>();
    await sessionService.saveSession(
      accessToken: accessToken,
      userName: displayName,
    );

    Get.offAllNamed(
      AppRoutes.mainNav,
      arguments: {'welcomeName': displayName},
    );
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

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
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

  String _buildLoginErrorMessage(ApiException error, String usernameInput) {
    final username = usernameInput.trim().toLowerCase();
    final message = error.message.trim().toLowerCase();
    final isEmailInput = username.contains('@');
    final looksLikeInvalidCredentials =
        error.statusCode == 401 &&
        (message.contains('invalid email or password') ||
            message.contains('invalid credentials') ||
            message.contains('unauthorized'));

    if (isEmailInput && looksLikeInvalidCredentials) {
      return 'This email is not registered yet. Please register first.';
    }

    return error.message;
  }

  String _extractEmail(Object? user, {required String fallback}) {
    if (user is Map<String, dynamic>) {
      final email = user['email']?.toString().trim() ?? '';
      if (email.isNotEmpty) {
        return email;
      }
    }

    return fallback.trim();
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

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      ).timeout(const Duration(seconds: 8));
      await FirebaseAuth.instance.signOut().timeout(const Duration(seconds: 8));
      return;
    } on FirebaseAuthException catch (error) {
      if (error.code != 'user-not-found') {
        return;
      }
    } catch (_) {
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      ).timeout(const Duration(seconds: 8));
      await FirebaseAuth.instance.signOut().timeout(const Duration(seconds: 8));
    } catch (_) {}
  }
}
