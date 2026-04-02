import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:school_assgn/core/auth/google_auth_service.dart';
import 'package:school_assgn/core/firebase/firebase_initializer.dart';
import 'package:school_assgn/core/session/session_service.dart';
import 'package:school_assgn/routes/app_pages.dart';
import 'package:school_assgn/routes/app_routes.dart';
import 'package:school_assgn/core/theme/theme_service.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow bad/self-signed certificates for development
  HttpOverrides.global = MyHttpOverrides();

  await _safeInitFirebase();

  final sessionService = SessionService();
  await _safeInitSession(sessionService);

  final themeService = await ThemeService().init();
  Get.put<ThemeService>(themeService, permanent: true);

  // Set initial system overlay style
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: themeService.isDarkMode.value
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarColor: themeService.isDarkMode.value
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      systemNavigationBarIconBrightness: themeService.isDarkMode.value
          ? Brightness.light
          : Brightness.dark,
    ),
  );

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
    final themeService = Get.find<ThemeService>();
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
        theme: ThemeService.lightTheme,
        darkTheme: ThemeService.darkTheme,
        themeMode: themeService.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
      ),
    );
  }
}
