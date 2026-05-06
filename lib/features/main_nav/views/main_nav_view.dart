import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:school_assgn/features/main_nav/controllers/main_nav_controller.dart';
import 'package:school_assgn/core/theme/theme_service.dart';
import 'package:school_assgn/themes/app_color.dart';

import 'package:school_assgn/features/home/views/home_view.dart';
import 'package:school_assgn/features/profile/views/profile_view.dart';
import 'package:school_assgn/widget/under_construction_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
class MainNavView extends GetView<MainNavController> {
  const MainNavView({super.key});

  static const _items = <_NavItemData>[
    _NavItemData(label: 'Home', iconAssetPath: 'assets/icons/house.svg'),
    _NavItemData(label: 'Search', iconAssetPath: 'assets/icons/search.svg'),
    _NavItemData(
      label: 'Alerts',
      iconAssetPath: 'assets/icons/bell-ring.svg',
    ),
    _NavItemData(label: 'Profile', iconAssetPath: 'assets/icons/user-round.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    return Scaffold(
      backgroundColor: AppColor.kBackground,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        top: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Obx(() {
                Widget activeView;
                switch (controller.currentIndex.value) {
                  case 0:
                    activeView = const HomeView(key: ValueKey(0));
                    break;
                  case 1:
                    activeView = const UnderConstructionView(
                      key: ValueKey(1),
                      title: 'Search',
                    );
                    break;
                  case 2:
                    activeView = const UnderConstructionView(
                      key: ValueKey(2),
                      title: 'Alerts',
                    );
                    break;
                  case 3:
                    activeView = const ProfileView(key: ValueKey(3));
                    break;
                  default:
                    activeView = const SizedBox.shrink(key: ValueKey(-1));
                }
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: activeView,
                );
              }),
            ),
            Builder(
              builder: (context) {
                final bool isKeyboardVisible =
                    MediaQuery.of(context).viewInsets.bottom > 0;
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isKeyboardVisible ? 0 : 1,
                    child: _buildNavBar(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    final themeService = Get.find<ThemeService>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: AppColor.kSurface.withValues(
              alpha: 0.9,
            ),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: AppColor.kBorder,
              width: AppColor.kBorderWidth,
            ),
          ),
          child: Obx(() {
            return Row(
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final selected = index == controller.currentIndex.value;
                return Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () => controller.changeTab(index),
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOut,
                        width: selected ? 48 : 40,
                        height: selected ? 48 : 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: selected
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColor.kNavSelectedStart,
                                    AppColor.kNavSelectedEnd,
                                  ],
                                )
                              : null,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            item.iconAssetPath,
                            width: selected ? 22 : 24,
                            height: selected ? 22 : 24,
                            colorFilter: ColorFilter.mode(
                              selected
                                  ? AppColor.kBackground
                                  : AppColor.kNavIcon,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({required this.label, required this.iconAssetPath});
  final String label;
  final String iconAssetPath;
}
