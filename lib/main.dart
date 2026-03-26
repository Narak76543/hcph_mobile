import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/core/auth/google_auth_service.dart';
import 'package:school_assgn/core/firebase/firebase_initializer.dart';
import 'package:school_assgn/core/session/session_service.dart';
import 'package:school_assgn/routes/app_pages.dart';
import 'package:school_assgn/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _safeInitFirebase();

  final sessionService = SessionService();
  await _safeInitSession(sessionService);

  Get.put<SessionService>(sessionService, permanent: true);
  Get.put<GoogleAuthService>(GoogleAuthService(), permanent: true);
  runApp(const MyApp());
}

Future<void> _safeInitFirebase() async {
  try {
    await ensureFirebaseInitialized().timeout(const Duration(seconds: 12));
  } on TimeoutException {
    debugPrint('Firebase initialization timed out.');
  } catch (error) {
    debugPrint('Firebase initialization failed: $error');
  }
}

Future<void> _safeInitSession(SessionService sessionService) async {
  try {
    await sessionService.init().timeout(const Duration(seconds: 6));
  } on TimeoutException {
    debugPrint('Session initialization timed out.');
  } catch (error) {
    debugPrint('Session initialization failed: $error');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
