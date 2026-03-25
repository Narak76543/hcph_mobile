import 'package:flutter/material.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class AuthPageScaffold extends StatelessWidget {
  const AuthPageScaffold({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kAuthBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: padding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - padding.vertical,
                  ),
                  child: IntrinsicHeight(child: child),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AuthInputField extends StatelessWidget {
  const AuthInputField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: AppColor.kAuthSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.kAuthBorder),
      ),
      alignment: Alignment.center,
      child: TextField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        cursorColor: AppColor.kAuthAccent,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 15,
          color: AppColor.kAuthTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: AppColor.kAuthTextSecondary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColor.kAuthAccent,
          foregroundColor: AppColor.kPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: AppText(
          title,
          variant: AppTextVariant.label,
          color: AppColor.kPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class AuthSocialButton extends StatelessWidget {
  const AuthSocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: AppText(
          label,
          variant: AppTextVariant.label,
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: borderColor == null ? 0 : 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

class AuthBottomLink extends StatelessWidget {
  const AuthBottomLink({
    super.key,
    required this.prompt,
    required this.linkLabel,
    required this.onTap,
  });

  final String prompt;
  final String linkLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          prompt,
          variant: AppTextVariant.caption,
          color: AppColor.kAuthTextSecondary,
        ),
        const Spacer(),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: AppText(
            linkLabel,
            variant: AppTextVariant.caption,
            color: AppColor.kAuthLink,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class GoogleGlyph extends StatelessWidget {
  const GoogleGlyph({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: const Text(
        'G',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF4285F4),
        ),
      ),
    );
  }
}
