import 'package:get/get.dart';

class SignInController extends GetxController {
  final RxBool rememberMe = false.obs;

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }
}
