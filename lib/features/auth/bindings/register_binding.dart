import 'package:get/get.dart';
import 'package:school_assgn/features/auth/controllers/register_controller.dart';
import 'package:school_assgn/features/auth/services/auth_api_service.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthApiService>()) {
      Get.lazyPut<AuthApiService>(() => AuthApiService(), fenix: true);
    }
    Get.lazyPut<RegisterController>(
      () => RegisterController(Get.find<AuthApiService>()),
    );
  }
}
