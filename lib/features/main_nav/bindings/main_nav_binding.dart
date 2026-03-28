import 'package:get/get.dart';
import 'package:school_assgn/features/main_nav/controllers/main_nav_controller.dart';

import 'package:school_assgn/features/home/controllers/home_controller.dart';
import 'package:school_assgn/features/builds/controllers/builds_controller.dart';
import 'package:school_assgn/features/alerts/controllers/alerts_controller.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>(() => MainNavController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<BuildsController>(() => BuildsController());
    Get.lazyPut<AlertsController>(() => AlertsController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
