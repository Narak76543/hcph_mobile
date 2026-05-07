import 'package:get/get.dart';
import 'package:school_assgn/features/auth/bindings/register_binding.dart';
import 'package:school_assgn/features/auth/bindings/sign_in_binding.dart';
import 'package:school_assgn/features/auth/views/auth_welcome_view.dart';
import 'package:school_assgn/features/auth/views/register_view.dart';
import 'package:school_assgn/features/auth/views/sign_in_view.dart';
import 'package:school_assgn/features/main_nav/bindings/main_nav_binding.dart';
import 'package:school_assgn/features/main_nav/views/main_nav_view.dart';
import 'package:school_assgn/features/onboarding/bindings/onboarding_binding.dart';
import 'package:school_assgn/features/onboarding/views/onboarding_view.dart';
import 'package:school_assgn/features/profile/bindings/edit_profile_binding.dart';
import 'package:school_assgn/features/profile/views/edit_profile_view.dart';
import 'package:school_assgn/features/splash/bindings/splash_binding.dart';
import 'package:school_assgn/features/splash/views/splash_views.dart';
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
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
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
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
