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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Alerts',
                variant: AppTextVariant.title,
                color: AppColor.kTextPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: AppText(
                    'No alerts yet',
                    variant: AppTextVariant.body,
                    color: AppColor.kTextSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
