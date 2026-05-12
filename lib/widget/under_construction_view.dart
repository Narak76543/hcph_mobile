import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class UnderConstructionView extends StatelessWidget {
  final String title;
  const UnderConstructionView({super.key, this.title = 'Under Construction'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: AppColor.kAuthAccent,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColor.kSurface,
              borderRadius: BorderRadius.circular(AppColor.kCardRadius),
              border: Border.all(
                color: AppColor.kBorder,
                width: AppColor.kBorderWidth,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔥 Icon Circle (better than plain image)
                Lottie.asset(
                  'assets/animations/Under-construction.json',
                  height: 186,
                  width: 186,
                  fit: BoxFit.contain,
                  repeat: true,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.check_circle_rounded,
                    color: AppColor.kSuccess,
                    size: 12,
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                AppText(
                  "$title Module ",
                  variant: AppTextVariant.title,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColor.kTextPrimary,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Description
                AppText(
                  'Coming Soon! We are hard at work building this feature for you. Thanks for waiting! ✨',
                  variant: AppTextVariant.body,
                  fontSize: 12,
                  color: AppColor.kTextSecondary,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.kGoogleBlue,
                      foregroundColor: AppColor.kOnAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppColor.kCardRadius,
                        ),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: AppText(
                      "Go Back",
                      color: AppColor.kAccent,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
