import 'package:get/get.dart';
import 'package:school_assgn/features/alerts/controllers/alerts_controller.dart';

class AlertsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlertsController>(() => AlertsController());
  }
}
