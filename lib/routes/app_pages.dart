import 'package:get/get.dart';
import 'package:school_assgn/features/auth/auth_welcome_view.dart';
import 'package:school_assgn/features/auth/bindings/register_binding.dart';
import 'package:school_assgn/features/auth/bindings/sign_in_binding.dart';
import 'package:school_assgn/features/auth/register_view.dart';
import 'package:school_assgn/features/auth/sign_in_view.dart';
import 'package:school_assgn/features/main_nav/bindings/main_nav_binding.dart';
import 'package:school_assgn/features/main_nav/main_nav_view.dart';
import 'package:school_assgn/features/splash/bindings/splash_binding.dart';
import 'package:school_assgn/features/splash/splash_views.dart';
import 'package:school_assgn/routes/app_routes.dart';

class AppPages {
  AppPages._();

  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashViews(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.signIn,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(name: AppRoutes.authWelcome, page: () => const AuthWelcomeView()),
    GetPage(
      name: AppRoutes.mainNav,
      page: () => const MainNavView(),
      binding: MainNavBinding(),
    ),
  ];
}
