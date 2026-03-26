import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/main_nav/controllers/main_nav_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class MainNavView extends GetView<MainNavController> {
  const MainNavView({super.key});

  static const _items = <_NavItemData>[
    _NavItemData(
      label: 'Home',
      iconAssetPath: 'assets/home.png',
    ),
    _NavItemData(
      label: 'Search',
      iconAssetPath: 'assets/images/search.png',
    ),
    _NavItemData(
      label: 'Alerts',
      iconAssetPath: 'assets/images/notification-bell.png',
    ),
    _NavItemData(
      label: 'Profile',
      iconAssetPath: 'assets/images/user.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/app-bg.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: ColoredBox(color: AppColor.kAuthBackgroundOverlay),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    final index = controller.currentIndex.value;
                    if (index == 3) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColor.kNavCardBackground,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.person_outline_rounded,
                                size: 58,
                                color: AppColor.kNavPrimaryText,
                              ),
                              const SizedBox(height: 10),
                              const AppText(
                                'Profile',
                                variant: AppTextVariant.title,
                                color: AppColor.kNavPrimaryText,
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: controller.logout,
                                  icon: const Icon(Icons.logout_rounded, size: 20),
                                  label: const AppText(
                                    'Log out',
                                    variant: AppTextVariant.label,
                                    color: AppColor.kTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.kNavSelectedBackground,
                                    foregroundColor: AppColor.kTextColor,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Center(
                      child: AppText(
                        '${_items[index].label} Screen',
                        variant: AppTextVariant.title,
                        color: AppColor.kNavPrimaryText,
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 390),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColor.kNavBarBackground.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: AppColor.kAuthBorder.withValues(alpha: 0.45),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.kNavPrimaryText.withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Obx(() {
                        final selectedIndex = controller.currentIndex.value;
                        return Row(
                          children: List.generate(_items.length, (index) {
                            final item = _items[index];
                            final selected = index == selectedIndex;
                            return Expanded(
                              child: Center(
                                child: GestureDetector(
                                  onTap: () => controller.changeTab(index),
                                  child: AnimatedScale(
                                    duration: const Duration(milliseconds: 220),
                                    curve: Curves.easeOutCubic,
                                    scale: selected ? 1.0 : 0.95,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 220),
                                      curve: Curves.easeOutCubic,
                                      width: selected ? 50 : 42,
                                      height: selected ? 50 : 42,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selected
                                            ? AppColor.kNavSelectedBackground
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: selected
                                              ? Colors.white.withValues(alpha: 0.18)
                                              : Colors.transparent,
                                          width: 1,
                                        ),
                                        boxShadow: selected
                                            ? [
                                                BoxShadow(
                                                  color: AppColor.kNavSelectedBackground
                                                      .withValues(alpha: 0.30),
                                                  blurRadius: 16,
                                                  spreadRadius: 0.8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ]
                                            : const [],
                                      ),
                                      child: Center(
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            selected
                                                ? AppColor.kTextColor
                                                : AppColor.kNavIcon,
                                            BlendMode.srcIn,
                                          ),
                                          child: Image.asset(
                                            item.iconAssetPath,
                                            width: selected ? 22 : 21,
                                            height: selected ? 22 : 21,
                                            fit: BoxFit.contain,
                                            filterQuality: FilterQuality.high,
                                          ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.label,
    required this.iconAssetPath,
  });

  final String label;
  final String iconAssetPath;
}
