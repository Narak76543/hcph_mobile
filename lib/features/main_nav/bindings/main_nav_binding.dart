import 'package:get/get.dart';
import 'package:school_assgn/features/main_nav/controllers/main_nav_controller.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>(() => MainNavController());
  }
}
