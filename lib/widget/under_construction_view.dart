// import 'package:flutter/material.dart';
// import 'package:school_assgn/themes/app_color.dart';
// import 'package:school_assgn/widget/text_widget.dart';

// class UnderConstructionView extends StatelessWidget {
//   final String title;
//   const UnderConstructionView({super.key, this.title = 'Under Construction'});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.kBgColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_rounded),
//           color: AppColor.kAuthAccent,
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 40),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Sticker
//               Image.asset(
//                 'assets/images/road-closed.png',
//                 width: 180,
//                 height: 180,
//                 fit: BoxFit.contain,
//               ),
//               const SizedBox(height: 32),

//               // Warning Title
//               AppText(
//                 title.toUpperCase(),
//                 variant: AppTextVariant.title,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w400,
//                 color: AppColor.kAccentDark,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),

//               // Descriptive Text
//               AppText(
//                 'ជម្រាបសួរអ្នកប្រើប្រាស់ជាទីមេត្រី ។ ដោយសារតែអ្នកសរសេរកូដ រវល់ក្រឡុកទីក្រុង​ និង លេងបៀ ដូចនេះមុខងារនេះត្រូវស្ថិតក្នុងការអភិវឌ្ឃន៍ រហូតដល់អ្នកសរសេរកូដមកពីចូលឆ្នាំវិញ ខដ',
//                 variant: AppTextVariant.body,
//                 fontSize: 18,
//                 color: AppColor.kSecondary,
//                 textAlign: TextAlign.center,
//               ),

//               const SizedBox(height: 48),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColor.kSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor.kBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColor.kShadow,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔥 Icon Circle (better than plain image)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColor.kAccent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/road-closed.png',
                    width: 80,
                    height: 80,
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                AppText(
                  title + " Module ",
                  variant: AppTextVariant.title,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: AppColor.kTextPrimary,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Description
                AppText(
                  'Coming Soon! We are hard at work building this feature for you. Thanks for waiting! ✨',
                  variant: AppTextVariant.body,
                  fontSize: 14,
                  color: AppColor.kTextSecondary,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.kAccent,
                      foregroundColor: AppColor.kOnAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Go Back",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
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
