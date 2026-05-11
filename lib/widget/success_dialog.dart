import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    super.key,
    this.title = 'Successful',
    required this.message,
    this.buttonText = 'Done',
    this.animationAsset = 'assets/animations/tick_animation.json',
    this.onDone,
  });

  final String title;
  final String message;
  final String buttonText;
  final String animationAsset;
  final VoidCallback? onDone;

  static Future<T?> show<T>({
    String title = 'Successful',
    required String message,
    String buttonText = 'Done',
    String animationAsset = 'assets/animations/Success tick.json',
    VoidCallback? onDone,
    bool barrierDismissible = false,
  }) {
    return Get.dialog<T>(
      SuccessDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        animationAsset: animationAsset,
        onDone: onDone,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  @override
  Widget build(BuildContext context) {
    HapticFeedback.lightImpact();

    Future.delayed(const Duration(seconds: 5), () {
    if (Get.isDialogOpen ?? false) {
      Get.back(); 
      onDone?.call(); 
    }
  });
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 26),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          padding: const EdgeInsets.fromLTRB(28, 34, 28, 28),
          decoration: BoxDecoration(
            color: AppColor.kSurface,
            borderRadius: BorderRadius.circular(34),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                animationAsset,
                height: 94,
                width: 94,
                fit: BoxFit.contain,
                repeat: true,
                errorBuilder: (_, _, _) => Icon(
                  Icons.check_circle_rounded,
                  color: AppColor.kSuccess,
                  size: 84,
                ),
              ),
              const SizedBox(height: 10),
              AppText(
                title,
                variant: AppTextVariant.title,
                color: AppColor.kTextPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              AppText(
                message,
                variant: AppTextVariant.body,
                color: AppColor.kTextSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 34),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    onDone?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColor.kGoogleBlue,
                    foregroundColor: AppColor.kOnAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppColor.kCardRadius),
                    ),
                  ),
                  child: AppText(
                    buttonText,
                    variant: AppTextVariant.label,
                    color: AppColor.kOnAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
