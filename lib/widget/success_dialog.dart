// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:school_assgn/themes/app_color.dart';
// import 'package:school_assgn/widget/text_widget.dart';

// class SuccessDialog extends StatelessWidget {
//   final String title;
//   final String message;
//   final String buttonText;
//   final VoidCallback? onButtonPressed;

//   const SuccessDialog({
//     super.key,
//     required this.title,
//     required this.message,
//     this.buttonText = 'Get Started',
//     this.onButtonPressed,
//   });

//   static void show({
//     required String title,
//     required String message,
//     String buttonText = 'Get Started',
//     VoidCallback? onButtonPressed,
//   }) {
//     Get.dialog(
//       SuccessDialog(
//         title: title,
//         message: message,
//         buttonText: buttonText,
//         onButtonPressed: onButtonPressed,
//       ),
//       barrierDismissible: false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       backgroundColor: AppColor.kBackground,
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: AppColor.kGoogleGreen.withValues(alpha: 0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(Icons.check_circle_rounded,
//                   color: AppColor.kGoogleGreen, size: 64),
//             ),
//             const SizedBox(height: 24),
//             AppText(
//               title,
//               variant: AppTextVariant.title,
//               fontSize: 20,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 12),
//             AppText(
//               message,
//               variant: AppTextVariant.body,
//               color: AppColor.kAuthTextSecondary,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Get.back();
//                   if (onButtonPressed != null) onButtonPressed!();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColor.kGoogleGreen,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 child: AppText(
//                   buttonText,
//                   variant: AppTextVariant.label,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'Continue',
    this.onButtonPressed,
  });

  static void show({
    required String title,
    required String message,
    String buttonText = 'Continue',
    VoidCallback? onButtonPressed,
  }) {
    Get.dialog(
      SuccessDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed,
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColor.kSurface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Soft success icon (better visual)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColor.kGoogleGreen.withValues(alpha: 0.15),
                    AppColor.kGoogleGreen.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Icon(
                Icons.check_rounded,
                color: AppColor.kGoogleGreen,
                size: 48, // smaller = cleaner
              ),
            ),

            const SizedBox(height: 22),

            // Title
            AppText(
              title,
              variant: AppTextVariant.title,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColor.kTextPrimary,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            // Message
            AppText(
              message,
              variant: AppTextVariant.body,
              fontSize: 14,
              color: AppColor.kTextSecondary,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 26),

            // ✅ Better button (modern feel)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  if (onButtonPressed != null) onButtonPressed!();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColor.kGoogleGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: AppText(
                  buttonText,
                  variant: AppTextVariant.label,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
