import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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

class AuthInputField extends StatefulWidget {
  const AuthInputField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.enabled = true,
    this.suffixIcon,
  });

  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final bool enabled;
  final Widget? suffixIcon;

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  late final FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!mounted) {
      return;
    }
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColor.kAuthSurface,
        borderRadius: BorderRadius.circular(AppColor.kCardRadius),
        border: Border.all(
          color: _hasFocus
              ? AppColor.kAuthAccent.withValues(alpha: 0.3)
              : AppColor.kAuthBorder,
          width: AppColor.kBorderWidth,
        ),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: widget.controller,
        enabled: widget.enabled,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        cursorColor: AppColor.kAuthAccent,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 15,
          color: AppColor.kAuthTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: _hasFocus ? '' : widget.hintText,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: AppColor.kAuthTextSecondary,
          ),
          suffixIcon: widget.suffixIcon,
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
    this.isLoading = false,
    this.enabled = true,
  });

  final String title;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: (isLoading || !enabled) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColor.kAuthSurface,
          foregroundColor: AppColor.kAuthTextPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColor.kCardRadius),
            side: BorderSide(
              color: AppColor.kAuthBorder,
              width: AppColor.kBorderWidth,
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 28,
                height: 28,
                child: LoadingAnimationWidget.discreteCircle(
                  color: AppColor.kGoogleRed,
                  secondRingColor: AppColor.kGoogleYellow,
                  thirdRingColor: AppColor.kGoogleGreen,
                  size: 28,
                ),
              )
            : AppText(
                title,
                variant: AppTextVariant.label,
                color: AppColor.kAuthTextPrimary,
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
    this.isLoading = false,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: LoadingAnimationWidget.discreteCircle(
                  color: AppColor.kGoogleRed,
                  secondRingColor: AppColor.kGoogleYellow,
                  thirdRingColor: AppColor.kGoogleGreen,
                  size: 20,
                ),
              )
            : icon,
        label: AppText(
          isLoading ? 'Please wait...' : label,
          variant: AppTextVariant.label,
          color: foregroundColor,
          fontWeight: FontWeight.w400,
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColor.kCardRadius),
            side: BorderSide(
              color: borderColor ?? AppColor.kAuthBorder,
              width: AppColor.kBorderWidth,
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
