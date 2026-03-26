import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:school_assgn/core/auth/google_auth_service.dart';
import 'package:school_assgn/core/firebase/firebase_initializer.dart';
import 'package:school_assgn/core/session/session_service.dart';
import 'package:school_assgn/routes/app_routes.dart';

class MainNavController extends GetxController {
  final RxInt currentIndex = 0.obs;

  @override
  void onReady() {
    super.onReady();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      final welcomeName = args['welcomeName']?.toString().trim() ?? '';
      if (welcomeName.isNotEmpty) {
        Get.snackbar('Welcome', 'Welcome back, $welcomeName!');
      }
    }
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  Future<void> logout() async {
    try {
      if (Get.isRegistered<GoogleAuthService>()) {
        final googleAuthService = Get.find<GoogleAuthService>();
        await googleAuthService.signOut();
      } else {
        await ensureFirebaseInitialized();
        await FirebaseAuth.instance.signOut();
      }
    } catch (_) {
      try {
        await ensureFirebaseInitialized();
        await FirebaseAuth.instance.signOut();
      } catch (_) {}
    }

    final sessionService = Get.find<SessionService>();
    await sessionService.clearSession();
    Get.offAllNamed(AppRoutes.signIn);
  }
}
