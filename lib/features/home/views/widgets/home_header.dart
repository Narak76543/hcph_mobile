import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Obx(_buildUserInfo),
          const Spacer(),
          const _NotificationBell(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    String avatarUrl =
        'https://ui-avatars.com/api/?name=U&background=0D8ABC&color=fff&size=128';
    String name = 'User';
    try {
      final pc = Get.find<ProfileController>();
      avatarUrl = pc.userAvatarUrl.value;
      name = pc.userName.value;
    } catch (_) {}

    return Row(
      children: [
        _Avatar(url: avatarUrl),
        const SizedBox(width: 10),
        _GreetingText(name: name),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String url;
  const _Avatar({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColor.kAuthAccent.withValues(alpha: 0.3),
          width: 2,
        ),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _GreetingText extends StatelessWidget {
  final String name;
  const _GreetingText({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Welcome Back',
          variant: AppTextVariant.caption,
          color: AppColor.kAuthTextSecondary,
          fontSize: 12,
        ),
        Row(
          children: [
            AppText(
              name,
              variant: AppTextVariant.title,
              color: AppColor.kAuthTextPrimary,
              fontSize: 15,
            ),
            const SizedBox(width: 4),
            const Text('🔥', style: TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.kAuthSurface,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: AppColor.kShadow, blurRadius: 8)],
      ),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          AppColor.kAuthTextPrimary,
          BlendMode.srcIn,
        ),
        child: Image.asset(
          'assets/images/notification-bell.png',
          width: 22,
          height: 22,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
