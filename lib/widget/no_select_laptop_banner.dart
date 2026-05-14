import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:school_assgn/features/main_nav/controllers/main_nav_controller.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';
import 'package:school_assgn/widget/text_widget.dart';

import '../themes/app_color.dart';

class NoSelectedLaptopBanner extends StatelessWidget {
  const NoSelectedLaptopBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: AppColor.kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.kBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/nothing.json',
            height: 160,
            width: 160,
            fit: BoxFit.contain,
            repeat: true,
            errorBuilder: (_, _, _) => Icon(
              Icons.laptop_mac_rounded,
              color: AppColor.kGoogleBlue,
              size: 64,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: AppText(
                    'No laptop selected yet!',
                    variant: AppTextVariant.title,
                    color: AppColor.kGoogleRed,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                AppText(
                  'Add your laptop model to see parts that fit your device.',
                  variant: AppTextVariant.body,
                  color: AppColor.kTextSecondary,
                  fontSize: 10.5,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openSelectLaptop(context),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColor.kGoogleBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppColor.kCardRadius),
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                    label: const AppText(
                      'Go now',
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openSelectLaptop(BuildContext context) {
    if (Get.isRegistered<MainNavController>()) {
      Get.find<MainNavController>().changeTab(3);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Get.isRegistered<ProfileController>()) return;

      final sheetContext = Get.context ?? context;
      Get.find<ProfileController>().showSetLaptopSheet(sheetContext);
    });
  }
}
