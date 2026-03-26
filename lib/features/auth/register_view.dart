import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/auth/controllers/register_controller.dart';
import 'package:school_assgn/features/auth/widgets/auth_widgets.dart';
import 'package:school_assgn/routes/app_routes.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageScaffold(
      backgroundImageAsset: 'assets/images/app-bg.jpg',
      backgroundOverlayColor: AppColor.kAuthBackgroundOverlay,
      child: Obx(() {
        final isSubmitting = controller.isSubmitting.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Get.offNamed(AppRoutes.signIn);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColor.kAuthTextPrimary,
              ),
              style: IconButton.styleFrom(
                backgroundColor: AppColor.kAuthSurface,
                side: const BorderSide(color: AppColor.kAuthBorder),
              ),
            ),
            const SizedBox(height: 22),
            const AppText(
              'Let\'s register account',
              variant: AppTextVariant.title,
              color: AppColor.kAuthTextPrimary,
              fontSize: 34,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 10),
            const AppText(
              'Fill your details based on the API schema.',
              variant: AppTextVariant.body,
              color: AppColor.kAuthTextSecondary,
              fontSize: 15,
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: AuthInputField(
                    hintText: 'Firstname',
                    controller: controller.firstnameController,
                    enabled: !isSubmitting,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AuthInputField(
                    hintText: 'Lastname',
                    controller: controller.lastnameController,
                    enabled: !isSubmitting,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AuthInputField(
                    hintText: 'Local FirstName',
                    controller: controller.firstnameLcController,
                    enabled: !isSubmitting,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AuthInputField(
                    hintText: 'Local LastName',
                    controller: controller.lastnameLcController,
                    enabled: !isSubmitting,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AuthInputField(
              hintText: 'Username',
              controller: controller.usernameController,
              enabled: !isSubmitting,
            ),
            const SizedBox(height: 12),
            AuthInputField(
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              controller: controller.emailController,
              enabled: !isSubmitting,
            ),
            const SizedBox(height: 12),
            AuthInputField(
              hintText: 'Phone number',
              keyboardType: TextInputType.phone,
              controller: controller.phoneNumberController,
              enabled: !isSubmitting,
            ),
            const SizedBox(height: 12),
            AuthInputField(
              hintText: 'Password',
              obscureText: true,
              controller: controller.passwordController,
              enabled: !isSubmitting,
            ),
            const SizedBox(height: 24),
            AuthPrimaryButton(
              title: 'Register',
              onPressed: controller.register,
              isLoading: isSubmitting,
            ),
            const SizedBox(height: 16),
            AuthSocialButton(
              label: 'Continue with Google',
              icon: Image.asset(
                'assets/images/google.png',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
              onPressed: isSubmitting ? null : controller.registerWithGoogle,
              backgroundColor: AppColor.kAuthAccent,
              foregroundColor: AppColor.kTextColor,
            ),
            const SizedBox(height: 12),
            AuthBottomLink(
              prompt: 'Already have an account?',
              linkLabel: 'Login',
              onTap: () {
                Get.offNamed(AppRoutes.signIn);
              },
            ),
          ],
        );
      }),
    );
  }
}
