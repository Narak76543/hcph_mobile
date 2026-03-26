import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:school_assgn/core/auth/google_account_sync.dart';
import 'package:school_assgn/core/firebase/firebase_initializer.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthResult {
  const GoogleAuthResult({
    required this.sessionToken,
    required this.firebaseUid,
    this.displayName,
    this.email,
  });

  final String sessionToken;
  final String firebaseUid;
  final String? displayName;
  final String? email;
}

class GoogleAuthException implements Exception {
  const GoogleAuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class GoogleAuthService {
  GoogleAuthService({GoogleSignIn? googleSignIn})
    : _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: ['email']);

  final GoogleSignIn _googleSignIn;

  Future<GoogleAuthResult?> signIn() async {
    try {
      await ensureFirebaseInitialized();

      // Force account chooser each time so user can switch Google account.
      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final googleAuth = await googleUser.authentication;
      if (_isEmpty(googleAuth.accessToken) && _isEmpty(googleAuth.idToken)) {
        throw const GoogleAuthException(
          'Google did not return authentication tokens. Please try again.',
        );
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-null',
          message: 'Google sign in failed. Please try again.',
        );
      }

      await _ensureEmailPasswordLink(
        user: user,
        password: buildGoogleLinkedPassword(user.uid),
      );

      final token = await user.getIdToken();

      return GoogleAuthResult(
        sessionToken: token ?? user.uid,
        firebaseUid: user.uid,
        displayName: user.displayName,
        email: user.email,
      );
    } on PlatformException catch (error) {
      throw GoogleAuthException(_mapPlatformError(error));
    } on FirebaseAuthException catch (error) {
      throw GoogleAuthException(
        error.message ?? 'Google sign in failed. Please try again.',
      );
    } on FirebaseException catch (error) {
      throw GoogleAuthException(_mapFirebaseError(error));
    }
  }

  Future<void> signOut() async {
    try {
      await ensureFirebaseInitialized();
    } catch (_) {
      return;
    }

    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}

    try {
      await _googleSignIn.disconnect();
    } catch (_) {}

    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }

  bool _isEmpty(String? value) => (value ?? '').trim().isEmpty;

  Future<void> linkCurrentUserWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    await _ensureEmailPasswordLink(
      user: user,
      explicitEmail: email,
      password: password,
    );
  }

  Future<void> _ensureEmailPasswordLink({
    required User user,
    required String password,
    String? explicitEmail,
  }) async {
    final email = (explicitEmail ?? user.email ?? '').trim();
    if (email.isEmpty) {
      return;
    }

    final hasPasswordProvider = user.providerData.any(
      (provider) => provider.providerId == 'password',
    );
    if (hasPasswordProvider) {
      return;
    }

    try {
      final emailCredential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.linkWithCredential(emailCredential);
    } catch (_) {
      // Keep Google login successful even if linking is not possible.
    }
  }

  String _mapPlatformError(PlatformException error) {
    final message = (error.message ?? '').toLowerCase();

    if (error.code == 'sign_in_canceled') {
      return 'Google sign in was canceled.';
    }

    if (error.code == 'network_error' || message.contains('network error')) {
      return 'Network error. Please check your internet connection.';
    }

    if (error.code == 'sign_in_failed' ||
        message.contains('apiexception: 10') ||
        message.contains('developer_error')) {
      return 'Google Sign-In config error. Add SHA-1/SHA-256 to Firebase, then download a new google-services.json.';
    }

    if (error.message != null && error.message!.trim().isNotEmpty) {
      return error.message!.trim();
    }

    return 'Google sign in failed. Please try again.';
  }

  String _mapFirebaseError(FirebaseException error) {
    final message = (error.message ?? '').trim();
    if (error.code == 'no-app') {
      return 'Firebase is not ready. Please restart the app and try again.';
    }

    if (message.isNotEmpty) {
      return message;
    }

    return 'Google sign in failed. Please try again.';
  }
}
