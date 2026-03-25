import 'package:get/get.dart';

class RegisterController extends GetxController {
  final RxBool sendEmptyFirstnameLc = false.obs;
  final RxBool sendEmptyLastnameLc = false.obs;
  final RxBool sendEmptyProfileImage = true.obs;

  void toggleFirstnameLcEmpty() {
    sendEmptyFirstnameLc.value = !sendEmptyFirstnameLc.value;
  }

  void toggleLastnameLcEmpty() {
    sendEmptyLastnameLc.value = !sendEmptyLastnameLc.value;
  }

  void toggleProfileImageEmpty() {
    sendEmptyProfileImage.value = !sendEmptyProfileImage.value;
  }
}
