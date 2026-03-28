import 'package:flutter/material.dart';
import 'package:school_assgn/themes/app_color.dart';

class AppInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? label;
  final TextInputType? keyboardType;
  final bool isPassword;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final double? verticalPadding;
  final Function(String)? onChanged;

  const AppInputField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.keyboardType,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.verticalPadding,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 5),
            child: Text(
              label!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.kTextSecondary,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppColor.kSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColor.kBorder.withOpacity(0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: TextStyle(
              color: AppColor.kTextPrimary,
              fontSize: 15,
              fontFamily: 'Poppins',
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColor.kTextSecondary.withOpacity(0.6),
                fontSize: 14,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: AppColor.kTextSecondary, size: 20)
                  : null,
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: verticalPadding ?? 13,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
