import 'package:get/get.dart';
import 'package:school_assgn/features/builds/controllers/builds_controller.dart';

class BuildsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuildsController>(() => BuildsController());
  }
}
