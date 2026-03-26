import 'package:get/get.dart';
import 'package:school_assgn/features/auth/controllers/sign_in_controller.dart';
import 'package:school_assgn/features/auth/services/auth_api_service.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthApiService>()) {
      Get.lazyPut<AuthApiService>(() => AuthApiService(), fenix: true);
    }
    Get.lazyPut<SignInController>(
      () => SignInController(Get.find<AuthApiService>()),
    );
  }
}
