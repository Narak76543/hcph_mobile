import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:school_assgn/core/auth/google_auth_service.dart';
import 'package:school_assgn/core/cache/api_cache_service.dart';
import 'package:school_assgn/core/firebase/firebase_initializer.dart';
import 'package:school_assgn/core/session/session_service.dart';
import 'package:school_assgn/routes/app_pages.dart';
import 'package:school_assgn/routes/app_routes.dart';
import 'package:school_assgn/core/theme/theme_service.dart';
import 'package:school_assgn/features/onboarding/controllers/onboarding_controller.dart';
import 'package:app_links/app_links.dart';
import 'package:school_assgn/services/telegram_auth_service.dart';

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

  final cacheService = await ApiCacheService().init();
  Get.put<ApiCacheService>(cacheService, permanent: true);

  final sessionService = SessionService();
  await _safeInitSession(sessionService);

  final themeService = await ThemeService().init();
  Get.put<ThemeService>(themeService, permanent: true);

  // Determine initial route here to skip splash screen
  String initialRoute = AppRoutes.onboarding;
  if (sessionService.isLoggedIn) {
    initialRoute = AppRoutes.mainNav;
  } else {
    final seenOnboarding = await OnboardingController.hasSeenOnboarding();
    if (seenOnboarding) {
      initialRoute = AppRoutes.signIn;
    }
  }

  // Set initial system overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF000000),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  Get.put<SessionService>(sessionService, permanent: true);
  Get.put<GoogleAuthService>(GoogleAuthService(), permanent: true);
  runApp(MyApp(initialRoute: initialRoute));
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

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  void _initDeepLinks() {
    _appLinks = AppLinks();

    // Listen for incoming deep links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('Incoming deep link: $uri');

      // Check if this is our telegram-auth callback
      if (uri.scheme == 'myapp' && uri.host == 'telegram-auth') {
        final params = Map<String, String>.from(uri.queryParameters);
        if (params.isNotEmpty) {
          TelegramAuthService.handleCallback(params, Get.context!);
        }
      }
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: widget.initialRoute,
      getPages: AppPages.pages,
      theme: ThemeService.darkTheme,
      darkTheme: ThemeService.darkTheme,
      themeMode: ThemeMode.dark,
    );
  }
}
