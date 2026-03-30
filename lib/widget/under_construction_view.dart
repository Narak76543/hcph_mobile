import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Sticker
              Image.asset(
                'assets/images/road-closed.png',
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),

              // Warning Title
              AppText(
                title.toUpperCase(),
                variant: AppTextVariant.title,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppColor.kAccentDark,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Descriptive Text
              AppText(
                'Jam tix kpong code hx ! jam ouy knea help code xD',
                variant: AppTextVariant.body,
                fontSize: 15,
                color: AppColor.kTextSecondary,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Return to Home button
              // SizedBox(
              //   width: double.infinity,
              //   height: 54,
              //   child: ElevatedButton(
              //     onPressed: () => Navigator.pop(context), // Or switch to initial tab?
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColor.kAuthAccent.withOpacity(0.1),
              //       foregroundColor: AppColor.kAuthAccent,
              //       elevation: 0,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         side: BorderSide(
              //           color: AppColor.kAuthAccent.withOpacity(0.2),
              //         ),
              //       ),
              //     ),
              //     child: const AppText(
              //       'Stay Tuned',
              //       variant: AppTextVariant.body,
              //       fontSize: 16,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
