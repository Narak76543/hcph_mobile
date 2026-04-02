import 'package:flutter/material.dart';
import 'package:school_assgn/themes/app_color.dart';

class AppInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? label;
  final TextInputType? keyboardType;
  final bool isPassword;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final double? verticalPadding;
  final Function(String)? onChanged;
  final bool labelAsHint;

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
    this.labelAsHint = false,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the active hint
    // If labelAsHint is true, we use the label as the primary hint, or the hint prop
    final String activeLabel = widget.label ?? widget.hint;
    final String activeHint = widget.labelAsHint ? activeLabel : widget.hint;
    final bool shouldHideHint = widget.labelAsHint && _isFocused;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && !widget.labelAsHint) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 5),
            child: Text(
              widget.label!,
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
            borderRadius: BorderRadius.circular(10), // Modern rounded
            border: Border.all(
              color: _isFocused ? AppColor.kGoogleBlue.withOpacity(0.5) : AppColor.kBorder.withOpacity(0.5),
              width: 1.5,
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
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.isPassword,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            style: TextStyle(
              color: AppColor.kTextPrimary,
              fontSize: 15,
              fontFamily: 'Poppins',
            ),
            decoration: InputDecoration(
              hintText: shouldHideHint ? '' : activeHint,
              hintStyle: TextStyle(
                color: AppColor.kTextSecondary.withOpacity(0.6),
                fontSize: 14,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: AppColor.kTextSecondary, size: 20)
                  : null,
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: widget.verticalPadding ?? 13,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
