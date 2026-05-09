import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/alerts/controllers/alerts_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class AlertsView extends GetView<AlertsController> {
  const AlertsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  AppText(
                    'Notifications',
                    variant: AppTextVariant.title,
                    color: AppColor.kTextPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.kError.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AppText(
                      '3 New',
                      variant: AppTextVariant.caption,
                      color: AppColor.kError,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildNotificationList()),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    final List<Map<String, dynamic>> dummyAlerts = [
      {
        'title': 'Price Alert',
        'desc': 'RAM DDR5 price dropped to \$55 by Shop X.',
        'time': '2h ago',
        'type': 'price',
        'icon': Icons.trending_down_rounded,
        'color': AppColor.kGoogleGreen,
      },
      {
        'title': 'New Expert Post',
        'desc': 'Shop owner John posted about RTX 4090 compatibility.',
        'time': '4h ago',
        'type': 'post',
        'icon': Icons.verified_user_rounded,
        'color': AppColor.kGoogleBlue,
      },
      {
        'title': 'System Update',
        'desc': 'HCPH v2.1.0 is now live. Check out new features!',
        'time': '1d ago',
        'type': 'system',
        'icon': Icons.system_update_rounded,
        'color': AppColor.kGoogleYellow,
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
      itemCount: dummyAlerts.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (ctx, i) {
        final alert = dummyAlerts[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.kSurface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColor.kBorder.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (alert['color'] as Color).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  alert['icon'] as IconData,
                  color: alert['color'] as Color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          alert['title'] as String,
                          variant: AppTextVariant.title,
                          color: AppColor.kTextPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        AppText(
                          alert['time'] as String,
                          variant: AppTextVariant.caption,
                          color: AppColor.kTextSecondary,
                          fontSize: 11,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    AppText(
                      alert['desc'] as String,
                      variant: AppTextVariant.body,
                      color: AppColor.kTextSecondary,
                      fontSize: 13,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
