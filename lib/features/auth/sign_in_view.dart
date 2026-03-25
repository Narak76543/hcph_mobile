import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/auth/controllers/sign_in_controller.dart';
import 'package:school_assgn/features/auth/widgets/auth_widgets.dart';
import 'package:school_assgn/routes/app_routes.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const AppText(
            'Let\'s sign in',
            variant: AppTextVariant.title,
            color: AppColor.kAuthTextPrimary,
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 10),
          const AppText(
            'Welcome Back,You have been missed.',
            variant: AppTextVariant.body,
            color: AppColor.kAuthTextSecondary,
            fontSize: 18,
          ),
          const SizedBox(height: 28),
          const AuthInputField(
            hintText: 'email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          const AuthInputField(hintText: 'password', obscureText: true),
          const SizedBox(height: 12),
          Row(
            children: [
              Obx(
                () => GestureDetector(
                  onTap: controller.toggleRememberMe,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: controller.rememberMe.value
                          ? AppColor.kAuthAccent
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColor.kAuthBorder,
                        width: 1.2,
                      ),
                    ),
                    child: controller.rememberMe.value
                        ? const Icon(
                            Icons.check,
                            size: 13,
                            color: AppColor.kPrimary,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const AppText(
                'Remember Me',
                variant: AppTextVariant.caption,
                color: AppColor.kAuthTextSecondary,
                fontSize: 14,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const AppText(
                  'Forgot Password',
                  variant: AppTextVariant.caption,
                  color: AppColor.kAuthLink,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AuthPrimaryButton(title: 'Log in', onPressed: () {}),
          const SizedBox(height: 20),
          const Center(
            child: AppText(
              'or continue with',
              variant: AppTextVariant.caption,
              color: AppColor.kAuthTextSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 20),
          // AuthSocialButton(
          //   label: 'Continue with Facebook',
          //   icon: const Icon(Icons.facebook, size: 20),
          //   onPressed: () {},
          //   backgroundColor: const Color(0xFF1F7BEE),
          //   foregroundColor: Colors.white,
          // ),
          const SizedBox(height: 12),
          AuthSocialButton(
            label: 'Continue with Google',
            icon: const GoogleGlyph(),
            onPressed: () {},
            backgroundColor: Colors.white,
            foregroundColor: AppColor.kPrimary,
          ),
          const SizedBox(height: 12),
          // AuthSocialButton(
          //   label: 'Continue with Apple',
          //   icon: const Icon(Icons.apple, size: 20),
          //   onPressed: () {},
          //   backgroundColor: Colors.transparent,
          //   foregroundColor: Colors.white,
          //   borderColor: AppColor.kAuthBorder,
          // ),
          const Spacer(),
          AuthBottomLink(
            prompt: 'Don\'t have any account?',
            linkLabel: 'Register Now',
            onTap: () {
              Get.offNamed(AppRoutes.register);
            },
          ),
        ],
      ),
    );
  }
}
