import 'package:get/get.dart';
import 'package:school_assgn/core/session/session_service.dart';
import 'package:school_assgn/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController {
  static const _kOnboardingSeen = 'onboarding_seen';

  final RxInt currentPage = 0.obs;

  final pages = const [
    OnboardingPage(
      tag: 'discover',
      headline: 'Find the Right Part',
      subheadline:
          'Check hardware compatibility for your laptop in seconds. Stop buying the wrong RAM.',
      badge: 'COMPATIBILITY',
      badgeIcon: 'check',
      accent: 0xFF6C63FF,
    ),
    OnboardingPage(
      tag: 'compare',
      headline: 'Compare Prices Instantly',
      subheadline:
          'See real prices from verified local shops across Phnom Penh, side by side.',
      badge: 'PRICING',
      badgeIcon: 'chart',
      accent: 0xFF00C9A7,
    ),
    OnboardingPage(
      tag: 'trust',
      headline: 'Trust the Experts',
      subheadline:
          'Verified technical posts from certified shop owners. No more guessing.',
      badge: 'VERIFIED',
      badgeIcon: 'shield',
      accent: 0xFF3D8BFF,
    ),
  ];

  void onPageChanged(int index) => currentPage.value = index;

  Future<void> skip() async => _finish();

  Future<void> next(int current) async {
    if (current >= pages.length - 1) {
      await _finish();
    }
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingSeen, true);

    final session = Get.find<SessionService>();
    Get.offAllNamed(session.isLoggedIn ? AppRoutes.mainNav : AppRoutes.signIn);
  }

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kOnboardingSeen) ?? false;
  }
}

class OnboardingPage {
  final String tag;
  final String headline;
  final String subheadline;
  final String badge;
  final String badgeIcon;
  final int accent;

  const OnboardingPage({
    required this.tag,
    required this.headline,
    required this.subheadline,
    required this.badge,
    required this.badgeIcon,
    required this.accent,
  });
}
