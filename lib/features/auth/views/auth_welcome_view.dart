import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/auth/widgets/auth_widgets.dart';
import 'package:school_assgn/routes/app_routes.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class AuthWelcomeView extends StatelessWidget {
  const AuthWelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const _WelcomeHeroCard(),
          const SizedBox(height: 32),
          AppText(
            'Let\'s register account',
            variant: AppTextVariant.title,
            color: AppColor.kAuthTextPrimary,
            fontSize: 39,
            fontWeight: FontWeight.w700,
            maxLines: 2,
          ),
          const SizedBox(height: 14),
          AppText(
            'Enjoy for reading and writing blog\nposts. Get \$ 1.00 dollars you referral\nyour friends.',
            variant: AppTextVariant.body,
            color: AppColor.kAuthTextSecondary,
            fontSize: 20,
          ),
          const Spacer(),
          AuthPrimaryButton(
            title: 'Get Started',
            onPressed: () {
              Get.toNamed(AppRoutes.register);
            },
          ),
          const SizedBox(height: 12),
          AuthBottomLink(
            prompt: 'Already have an account?',
            linkLabel: 'Login',
            onTap: () {
              Get.toNamed(AppRoutes.signIn);
            },
          ),
        ],
      ),
    );
  }
}

class _WelcomeHeroCard extends StatelessWidget {
  const _WelcomeHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.kPrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.kAuthBorder.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColor.kAuthSurface,
          image: const DecorationImage(
            image: AssetImage('assets/images/mac.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.40),
                Colors.black.withOpacity(0.86),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _messageCard(
                  text: 'How can AI optimize my\nbusiness processes quickly?',
                  avatarColor: const Color(0xFF31E2D5),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: _messageCard(
                    text:
                        'How long will the integration\nprocess usually take?',
                    avatarColor: const Color(0xFF7FA6FF),
                  ),
                ),
                const SizedBox(height: 10),
                _messageCard(
                  text: 'Can AI help streamline\noperations and reduce costs?',
                  avatarColor: const Color(0xFF25DDB7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _messageCard({required String text, required Color avatarColor}) {
    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.kAuthBackground.withOpacity(0.84),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: avatarColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.person, color: AppColor.kPrimary, size: 15),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppText(
              text,
              variant: AppTextVariant.caption,
              color: AppColor.kAuthTextPrimary,
              fontSize: 9.8,
            ),
          ),
        ],
      ),
    );
  }
}
