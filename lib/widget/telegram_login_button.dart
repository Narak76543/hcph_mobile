// TELEGRAM LOGIN - lib/widgets/telegram_login_button.dart
import 'package:flutter/material.dart';
import 'package:school_assgn/themes/app_color.dart';

class TelegramLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const TelegramLoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54, // Exact height requested
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.kAuthSurface, // Dark grey surface
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          side: BorderSide(
            color: AppColor.kAuthBorder.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: 0,
              child: Image.asset(
                'assets/images/telegram.png',
                width: 25,
                height: 25,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Continue with Telegram",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500, // Fixed syntax error
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
