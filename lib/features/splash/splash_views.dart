import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          children: const [
            AppText(
              'School Assgn',
              variant: AppTextVariant.title,
              color: AppColor.kAuthTextPrimary,
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: AppColor.kAuthAccent,
              ),
            ),
            SizedBox(height: 12),
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
