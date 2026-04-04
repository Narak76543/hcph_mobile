import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/builds/controllers/builds_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class BuildsView extends GetView<BuildsController> {
  const BuildsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      'My Builds',
                      variant: AppTextVariant.title,
                      color: AppColor.kTextPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor.kAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.add_rounded, color: AppColor.kAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(child: _buildEmptyState()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColor.kSurface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColor.kBorder.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.computer_rounded,
              size: 64,
              color: AppColor.kAccent.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 32),
          AppText(
            'No Builds Yet',
            variant: AppTextVariant.title,
            color: AppColor.kTextPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: AppText(
              'Start your first PC build journey by adding compatible parts to your list.',
              variant: AppTextVariant.body,
              color: AppColor.kTextSecondary,
              textAlign: TextAlign.center,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.rocket_launch_rounded, size: 20),
            label: const Text('Create New Build'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.kAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
