import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/onboarding/controllers/onboarding_controller.dart';
import 'package:school_assgn/routes/app_routes.dart';
import 'package:school_assgn/core/theme/theme_service.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final pageCtrl = PageController();

    return Scaffold(
      backgroundColor: AppColor.kBackground,
      body: Stack(
        children: [
          // Fixed MacBook background for all pages
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset('assets/images/nu.png', fit: BoxFit.cover),
            ),
          ),
          // Dynamic gradient overlay based on theme
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                    Colors.black,
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),
          // Content PageView
          PageView.builder(
            controller: pageCtrl,
            itemCount: controller.pages.length,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (context, index) {
              return _buildPage(controller.pages[index]);
            },
          ),
          // Top row: Logo + Skip
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.kSurface.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColor.kTextPrimary.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.memory_rounded,
                              color: AppColor.kTextPrimary,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            AppText(
                              'HCPH',
                              variant: AppTextVariant.caption,
                              color: AppColor.kTextPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Skip button
                  Obx(() {
                    if (controller.currentPage.value ==
                        controller.pages.length - 1) {
                      return const SizedBox.shrink();
                    }
                    return GestureDetector(
                      onTap: controller.skip,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.kSurface.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: AppColor.kTextPrimary.withValues(alpha: 0.15),
                              ),
                            ),
                            child: AppText(
                              'Skip',
                              variant: AppTextVariant.caption,
                              color: AppColor.kTextSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          // Bottom: dots + button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Obx(() {
                  final idx = controller.currentPage.value;
                  final page = controller.pages[idx];
                  final accentColor = Color(page.accent);
                  final isLast = idx == controller.pages.length - 1;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Page dots
                      Row(
                        children: List.generate(controller.pages.length, (i) {
                          final selected = i == idx;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.only(right: 8),
                            width: selected ? 28 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: selected
                                  ? accentColor
                                  : AppColor.kTextPrimary.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 32),
                      // Action button
                      SizedBox(
                        height: 58,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isLast) {
                              controller.next(idx);
                            } else {
                              pageCtrl.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isLast ? 'Get Started' : 'Continue',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                isLast
                                    ? Icons.rocket_launch_rounded
                                    : Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isLast) ...[
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.signIn),
                          child: Center(
                            child: AppText(
                              'Power by : Sarat Narak @02-APR-2026',
                              variant: AppTextVariant.caption,
                              color: AppColor.kTextSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    final accentColor = Color(page.accent);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Badge
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accentColor.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _badgeIcon(page.badgeIcon),
                        color: accentColor,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        page.badge,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: accentColor,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Headline
            Text(
              page.headline,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 36,
                height: 1.2,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // Subheadline
            Text(
              page.subheadline,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                height: 1.6,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 16),
            // Feature chips
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: _chips(page.tag, accentColor),
            ),
          ],
        ),
      ),
    );
  }

  IconData _badgeIcon(String key) {
    switch (key) {
      case 'check':
        return Icons.check_circle_rounded;
      case 'chart':
        return Icons.bar_chart_rounded;
      case 'shield':
        return Icons.verified_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  List<Widget> _chips(String tag, Color accent) {
    final chipData = {
      'discover': ['RAM', 'SSD', 'Battery', 'GPU'],
      'compare': ['Local Shops', 'Live Prices', 'Best Deals'],
      'trust': ['Certified Shops', 'Expert Posts', 'Khmer Support'],
    };
    final labels = chipData[tag] ?? [];
    return labels.map((label) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      );
    }).toList();
  }
}
