import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/home/models/home_models.dart'; // From previous step
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class LaptopDetailView extends StatelessWidget {
  final String modelName;
  final LaptopSpecModel spec;

  const LaptopDetailView({
    super.key,
    required this.modelName,
    required this.spec,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBgColor,
      appBar: AppBar(
        title: AppText(modelName, variant: AppTextVariant.title, fontSize: 18),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. RAM INFORMATION ──
            _buildSectionHeader('RAM Details', Icons.memory_rounded),
            _buildInfoCard([
              _buildDetailRow('RAM Type', spec.ramType ?? 'N/A'),
              _buildDetailRow('RAM Slots', '${spec.ramSlots ?? 0} slots'),
              _buildDivider(),
              _buildDetailRow('Base RAM', '${spec.ramBaseGb ?? 0} GB'),
              _buildDetailRow('Max Supported', '${spec.maxRamGg ?? 0} GB'),
            ]),
            const SizedBox(height: 24),

            // ── 2. SSD & STORAGE ──
            _buildSectionHeader('Storage Information', Icons.storage_rounded),
            _buildInfoCard([
              _buildDetailRow('SSD Slots', '${spec.ssdSlots ?? 0} slots'),
              _buildDetailRow('SSD Interface', spec.ssdInterface ?? 'N/A'),
              _buildDetailRow('SSD Form Factor', spec.ssdFromFactor ?? 'N/A'),
              _buildDivider(),
              _buildDetailRow(
                'Additional HDD Bay',
                spec.hasHddBay == true ? 'Yes' : 'No',
              ),
            ]),
            const SizedBox(height: 24),

            // ── 3. DISPLAY DETAILS ──
            _buildSectionHeader(
              'Display Specifications',
              Icons.monitor_rounded,
            ),
            _buildInfoCard([
              _buildDetailRow('Display Size', spec.displaySize ?? 'N/A'),
              _buildDetailRow(
                'Display Resolution',
                spec.displayResolution ?? 'N/A',
              ),
            ]),
            const SizedBox(height: 100), // Pull from bottom
          ],
        ),
      ),
    );
  }

  // Helper: Section Label
  Widget _buildSectionHeader(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColor.kGoogleBlue, size: 20),
          const SizedBox(width: 8),
          AppText(label, variant: AppTextVariant.title, fontSize: 16),
        ],
      ),
    );
  }

  // Helper: Card Style for info blocks
  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.kAuthSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.kAuthBorder.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColor.kShadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(children: children),
    );
  }

  // Helper: Individual Detail Row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            label,
            variant: AppTextVariant.body,
            color: AppColor.kAuthTextSecondary,
            fontSize: 13,
          ),
          AppText(value, variant: AppTextVariant.title, fontSize: 14),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        height: 1,
        color: AppColor.kAuthBorder.withValues(alpha: 0.4),
      ),
    );
  }
}
