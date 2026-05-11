import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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
    final imageProvider = url.startsWith('assets/')
        ? AssetImage(url) as ImageProvider
        : NetworkImage(url);

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColor.kBorder,
          width: AppColor.kBorderWidth,
        ),
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
                Lottie.asset(
                'assets/animations/Fire.json',
                height: 16,
                width: 16,
                fit: BoxFit.contain,
                repeat: true,
                errorBuilder: (_, _, _) => Icon(
                  Icons.check_circle_rounded,
                  color: AppColor.kSuccess,
                  size: 12,
                ),
              ),
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
        color: AppColor.kSurface,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColor.kBorder,
          width: AppColor.kBorderWidth,
        ),
      ),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          AppColor.kAuthTextPrimary,
          BlendMode.srcIn,
        ),
        child: SvgPicture.asset('assets/icons/bell-ring.svg'),
      ),
    );
  }
}
