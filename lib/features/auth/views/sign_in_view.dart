import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
      backgroundImageAsset: 'assets/images/app-bg.jpg',
      backgroundOverlayColor: AppColor.kAuthBackgroundOverlay,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          AppText(
            'Let\'s sign in',
            variant: AppTextVariant.title,
            color: AppColor.kAuthTextPrimary,
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 10),
          AppText(
            'Welcome Back,You have been missed.',
            variant: AppTextVariant.body,
            color: AppColor.kAuthTextSecondary,
            fontSize: 18,
          ),
          const SizedBox(height: 14),
          const _SloganCard(),
          const SizedBox(height: 22),
          Obx(
            () => AuthInputField(
              hintText: 'Email or Username',
              keyboardType: TextInputType.emailAddress,
              controller: controller.usernameController,
              enabled: !controller.isSubmitting.value,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => AuthInputField(
              hintText: 'Password',
              obscureText: controller.obscurePassword.value,
              controller: controller.passwordController,
              enabled: !controller.isSubmitting.value,
              suffixIcon: IconButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : controller.togglePasswordVisibility,
                icon: Icon(
                  controller.obscurePassword.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColor.kAuthTextSecondary,
                ),
              ),
            ),
          ),
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
                        ? Icon(
                            Icons.check,
                            size: 13,
                            color: AppColor.kTextColor,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              AppText(
                'Remember Me',
                variant: AppTextVariant.caption,
                color: AppColor.kAuthTextSecondary,
                fontSize: 14,
              ),
              const Spacer(),
              Obx(
                () => TextButton(
                  onPressed: controller.isResetSending.value
                      ? null
                      : controller.openForgotPasswordDialog,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: controller.isResetSending.value
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: LoadingAnimationWidget.discreteCircle(
                            color: AppColor.kGoogleBlue,
                            secondRingColor: AppColor.kGoogleRed,
                            thirdRingColor: AppColor.kGoogleYellow,
                            size: 16,
                          ),
                        )
                      : AppText(
                          'Forgot Password',
                          variant: AppTextVariant.caption,
                          color: AppColor.kAuthLink,
                          fontSize: 13,
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => AuthPrimaryButton(
              title: 'Log in',
              onPressed: controller.signIn,
              isLoading: controller.isEmailSubmitting.value,
              enabled: !controller.isGoogleSubmitting.value,
            ),
          ),
          const SizedBox(height: 18),
          const _ContinueWithDivider(),
          const SizedBox(height: 20),
          Obx(
            () => AuthSocialButton(
              label: 'Continue with Google',
              icon: Image.asset(
                'assets/images/google.png',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
              onPressed: controller.isSubmitting.value
                  ? null
                  : controller.signInWithGoogle,
              backgroundColor: AppColor.kAuthAccent,
              foregroundColor: AppColor.kTextColor,
              isLoading: controller.isGoogleSubmitting.value,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                'Don\'t have any account ?',
                variant: AppTextVariant.caption,
                color: AppColor.kAuthTextSecondary,
              ),
              const SizedBox(width: 10),
              AppText(
                '|',
                variant: AppTextVariant.caption,
                color: AppColor.kAuthTextSecondary,
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  Get.offNamed(AppRoutes.register);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: AppText(
                  'Register Now',
                  variant: AppTextVariant.caption,
                  color: AppColor.kAuthLink,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SloganCard extends StatelessWidget {
  const _SloganCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.kAuthSurface.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'HCPH Slogan',
            variant: AppTextVariant.caption,
            color: AppColor.kAuthLink,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                height: 1.35,
                color: AppColor.kAuthTextPrimary,
                fontWeight: FontWeight.w400,
              ),
              children: [
                const TextSpan(text: 'Check Specs. '),
                const TextSpan(
                  text: 'Compare Prices. ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const TextSpan(text: 'Trust Experts with '),
                TextSpan(
                  text: 'HCPH',
                  style: TextStyle(
                    color: AppColor.kAuthLink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueWithDivider extends StatelessWidget {
  const _ContinueWithDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: AppColor.kAuthBorder)),
        const SizedBox(width: 16),
        AppText(
          'or continue with',
          variant: AppTextVariant.caption,
          color: AppColor.kAuthTextSecondary,
          fontSize: 15,
        ),
        const SizedBox(width: 16),
        Expanded(child: Container(height: 1, color: AppColor.kAuthBorder)),
      ],
    );
  }
}
