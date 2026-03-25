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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const _RegisterFieldBlock(
            label: 'firstname',
            type: 'string',
            isRequired: true,
            field: AuthInputField(hintText: 'string'),
          ),
          const SizedBox(height: 16),
          const _RegisterFieldBlock(
            label: 'lastname',
            type: 'string',
            isRequired: true,
            field: AuthInputField(hintText: 'string'),
          ),
          const SizedBox(height: 16),
          _RegisterFieldBlock(
            label: 'firstname_lc',
            type: 'string',
            field: const AuthInputField(hintText: 'string'),
            trailing: Obx(
              () => _SendEmptyValueRow(
                value: controller.sendEmptyFirstnameLc.value,
                onChanged: (_) => controller.toggleFirstnameLcEmpty(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _RegisterFieldBlock(
            label: 'lastname_lc',
            type: 'string',
            field: const AuthInputField(hintText: 'string'),
            trailing: Obx(
              () => _SendEmptyValueRow(
                value: controller.sendEmptyLastnameLc.value,
                onChanged: (_) => controller.toggleLastnameLcEmpty(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _RegisterFieldBlock(
            label: 'username',
            type: 'string',
            isRequired: true,
            field: AuthInputField(hintText: 'string'),
          ),
          const SizedBox(height: 16),
          const _RegisterFieldBlock(
            label: 'email',
            type: 'string(\$email)',
            isRequired: true,
            field: AuthInputField(
              hintText: 'user@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(height: 16),
          const _RegisterFieldBlock(
            label: 'phone_number',
            type: 'string',
            isRequired: true,
            field: AuthInputField(
              hintText: 'string',
              keyboardType: TextInputType.phone,
            ),
          ),
          const SizedBox(height: 16),
          const _RegisterFieldBlock(
            label: 'password',
            type: 'string',
            isRequired: true,
            field: AuthInputField(hintText: 'string', obscureText: true),
          ),
          const SizedBox(height: 16),
          _RegisterFieldBlock(
            label: 'profile_image',
            type: 'string(\$binary)',
            field: const AuthInputField(hintText: 'string(\$binary)'),
            trailing: Obx(
              () => _SendEmptyValueRow(
                value: controller.sendEmptyProfileImage.value,
                onChanged: (_) => controller.toggleProfileImageEmpty(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          AuthPrimaryButton(title: 'Register', onPressed: () {}),
          const SizedBox(height: 12),
          AuthBottomLink(
            prompt: 'Already have an account?',
            linkLabel: 'Login',
            onTap: () {
              Get.offNamed(AppRoutes.signIn);
            },
          ),
        ],
      ),
    );
  }
}

class _RegisterFieldBlock extends StatelessWidget {
  const _RegisterFieldBlock({
    required this.label,
    required this.type,
    required this.field,
    this.isRequired = false,
    this.trailing,
  });

  final String label;
  final String type;
  final Widget field;
  final bool isRequired;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText(
              label,
              variant: AppTextVariant.label,
              color: AppColor.kAuthTextPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
            if (isRequired) ...[
              const SizedBox(width: 5),
              const AppText(
                '*',
                variant: AppTextVariant.label,
                color: AppColor.kError,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(width: 5),
              const AppText(
                'required',
                variant: AppTextVariant.caption,
                color: AppColor.kError,
                fontWeight: FontWeight.w500,
              ),
            ],
          ],
        ),
        const SizedBox(height: 2),
        AppText(
          type,
          variant: AppTextVariant.caption,
          color: AppColor.kAuthTextSecondary,
        ),
        const SizedBox(height: 8),
        field,
        if (trailing != null) ...[const SizedBox(height: 8), trailing!],
      ],
    );
  }
}

class _SendEmptyValueRow extends StatelessWidget {
  const _SendEmptyValueRow({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColor.kAuthAccent,
            checkColor: AppColor.kPrimary,
            side: const BorderSide(color: AppColor.kAuthBorder),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 10),
        const AppText(
          'Send empty value',
          variant: AppTextVariant.caption,
          color: AppColor.kAuthTextSecondary,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
