import 'dart:async';

import 'package:get/get.dart';
import 'package:school_assgn/routes/app_routes.dart';

class SplashController extends GetxController {
  Timer? _timer;

  @override
  void onReady() {
    super.onReady();
    _timer = Timer(const Duration(seconds: 2), () {
      Get.offNamed(AppRoutes.signIn);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
