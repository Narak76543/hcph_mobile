import 'dart:async';

import 'package:get/get.dart';
import 'package:school_assgn/core/session/session_service.dart';
import 'package:school_assgn/routes/app_routes.dart';

class SplashController extends GetxController {
  Timer? _timer;

  @override
  void onReady() {
    super.onReady();
    _timer = Timer(const Duration(seconds: 2), () {
      final sessionService = Get.find<SessionService>();
      final targetRoute = sessionService.isLoggedIn
          ? AppRoutes.mainNav
          : AppRoutes.signIn;
      Get.offAllNamed(targetRoute);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
