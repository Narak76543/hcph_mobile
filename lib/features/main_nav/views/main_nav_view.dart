import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:school_assgn/features/main_nav/controllers/main_nav_controller.dart';
import 'package:school_assgn/core/theme/theme_service.dart';
import 'package:school_assgn/themes/app_color.dart';

import 'package:school_assgn/features/home/views/home_view.dart';
import 'package:school_assgn/features/profile/views/profile_view.dart';
import 'package:school_assgn/widget/under_construction_view.dart';

class MainNavView extends GetView<MainNavController> {
  const MainNavView({super.key});

  static const _items = <_NavItemData>[
    _NavItemData(label: 'Home', iconAssetPath: 'assets/home.png'),
    _NavItemData(label: 'Search', iconAssetPath: 'assets/images/search.png'),
    _NavItemData(
      label: 'Alerts',
      iconAssetPath: 'assets/images/notification-bell.png',
    ),
    _NavItemData(label: 'Profile', iconAssetPath: 'assets/images/user.png'),
  ];

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    return Obx(() {
      final isDark = themeService.isDarkMode.value;

      return Scaffold(
        backgroundColor: AppColor.kBackground,
        body: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: AppColor.kBackground)),
            Positioned.fill(
              child: Opacity(
                opacity: isDark ? 0.35 : 0.15,
                child: Image.asset(
                  'assets/images/app-bg.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: ColoredBox(
                color: AppColor.kOverlay.withOpacity(isDark ? 0.85 : 0.9),
              ),
            ),
            SafeArea(
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
                  Builder(builder: (context) {
                    final bool isKeyboardVisible =
                        MediaQuery.of(context).viewInsets.bottom > 0;
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      left: 0,
                      right: 0,
                      bottom: isKeyboardVisible ? -100 : 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isKeyboardVisible ? 0 : 1,
                        child: _buildNavBar(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNavBar() {
    final themeService = Get.find<ThemeService>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Obx(() {
          final isDark = themeService.isDarkMode.value;
          return ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColor.kSurface.withOpacity(isDark ? 0.4 : 0.6),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: AppColor.kGlassBorder.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
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
                            // ✅ FIX 1: easeInOut never overshoots → spreadRadius stays >= 0
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
                              boxShadow: [
                                // ✅ FIX 2: spreadRadius always 0 — removes overshoot crash
                                BoxShadow(
                                  color: selected
                                      ? AppColor.kNavSelectedEnd.withOpacity(
                                          0.4,
                                        )
                                      : Colors.transparent,
                                  blurRadius: selected ? 12.0 : 0.0,
                                  spreadRadius: 0.0, // ← was: selected ? 1 : 0
                                  offset: selected
                                      ? const Offset(0, 4)
                                      : const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Center(
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  selected ? Colors.white : AppColor.kNavIcon,
                                  BlendMode.srcIn,
                                ),
                                child: Image.asset(
                                  item.iconAssetPath,
                                  width: selected ? 22 : 24,
                                  height: selected ? 22 : 24,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({required this.label, required this.iconAssetPath});
  final String label;
  final String iconAssetPath;
}
