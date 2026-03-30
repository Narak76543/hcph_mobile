import 'package:flutter/material.dart';
import 'package:school_assgn/themes/app_color.dart';

enum AppTextVariant { heading, title, body, caption, label }

class AppText extends StatelessWidget {
  final String text;
  final AppTextVariant variant;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;

  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.body,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
    this.fontWeight,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: _style().copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration,
      ),
    );
  }

  TextStyle _style() {
    switch (variant) {
      case AppTextVariant.heading:
        return TextStyle(
          fontFamily: 'Poppins',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1.3,
        );
      case AppTextVariant.title:
        return TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.4,
        );
      case AppTextVariant.body:
        return TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: 1.6,
        );
      case AppTextVariant.caption:
        return TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.5,
        );
      case AppTextVariant.label:
        return TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          height: 1.4,
        );
    }
  }
}
