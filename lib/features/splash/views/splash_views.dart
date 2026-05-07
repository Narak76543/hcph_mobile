import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:school_assgn/features/splash/controllers/splash_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class SplashViews extends GetView<SplashController> {
  const SplashViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kAuthBackground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/nu.png',
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 36,
              height: 36,
              child: LoadingAnimationWidget.discreteCircle(
                color: AppColor.kGoogleBlue,
                secondRingColor: AppColor.kGoogleRed,
                thirdRingColor: AppColor.kGoogleYellow,
                size: 36,
              ),
            ),
            const SizedBox(height: 12),
            AppText(
              'Loading...',
              variant: AppTextVariant.caption,
              color: AppColor.kAuthTextSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
