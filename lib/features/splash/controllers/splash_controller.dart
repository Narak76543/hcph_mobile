import 'dart:async';

import 'package:get/get.dart';
import 'package:school_assgn/core/session/session_service.dart';
import 'package:school_assgn/features/onboarding/controllers/onboarding_controller.dart';
import 'package:school_assgn/routes/app_routes.dart';

class SplashController extends GetxController {
  Timer? _timer;

  @override
  void onReady() {
    super.onReady();
    _timer = Timer(const Duration(seconds: 2), _navigate);
  }

  Future<void> _navigate() async {
    final session = Get.find<SessionService>();

    // If already logged in, skip onboarding entirely
    if (session.isLoggedIn) {
      Get.offAllNamed(AppRoutes.mainNav);
      return;
    }

    // First-time user → show onboarding
    final seenOnboarding = await OnboardingController.hasSeenOnboarding();
    if (!seenOnboarding) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else {
      Get.offAllNamed(AppRoutes.signIn);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
