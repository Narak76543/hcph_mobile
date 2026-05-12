import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class UpgradeGuideCard extends StatelessWidget {
  const UpgradeGuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pc = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : null;

      if (pc == null || pc.myLaptops.isEmpty) return const SizedBox.shrink();

      final laptop = pc.myLaptops.first;
      final model = laptop['laptop_model'];
      final spec = model?['spec'];
      final modelName = model?['name']?.toString() ?? 'Your Laptop';

      if (spec == null) return const SizedBox.shrink();

      final items = _buildUpgradeItems(spec);

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
        decoration: BoxDecoration(
          color: AppColor.kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColor.kBorder.withValues(alpha: 0.8),
            width: AppColor.kBorderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.kShadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'What can your $modelName upgrade?',
              variant: AppTextVariant.title,
              color: AppColor.kTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 16),
            ...items.map(
              (item) => _UpgradeItem(
                label: item['label']!,
                description: item['description']!,
                supported: item['supported'] == 'true',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: navigate to compatible parts
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.kGoogleBlue,
                  foregroundColor: const Color(0xFF3478D8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const AppText(
                  'Find Compatible Parts',
                  variant: AppTextVariant.body,
                  color: AppColor.kAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Map<String, String>> _buildUpgradeItems(Map spec) {
    final items = <Map<String, String>>[];

    final ramSlots = int.tryParse(spec['ram_slots']?.toString() ?? '0') ?? 0;
    final maxRam = spec['max_ram_gg']?.toString() ?? '';
    final ramType = spec['ram_type']?.toString() ?? '';

    if (ramSlots == 0) {
      items.add({
        'label': 'RAM soldered (check first version)',
        'description': '',
        'supported': 'false',
      });
    } else {
      items.add({
        'label': 'RAM (up to ${maxRam}GB $ramType)',
        'description': '',
        'supported': 'true',
      });
    }

    final ssdSlots = int.tryParse(spec['ssd_slots']?.toString() ?? '0') ?? 0;
    final ssdIface = spec['ssd_interface']?.toString() ?? 'NVMe';
    final ssdFactor = spec['ssd_from_factor']?.toString() ?? 'M.2';

    if (ssdSlots > 0) {
      items.add({
        'label':
            '$ssdFactor $ssdIface SSD ($ssdSlots slot${ssdSlots > 1 ? 's' : ''} available)',
        'description': '',
        'supported': 'true',
      });
    } else {
      items.add({
        'label': 'SSD (no slot available)',
        'description': '',
        'supported': 'false',
      });
    }

    final hasHdd = spec['has_hdd_bay'] == true;
    items.add({
      'label': 'HDD Bay (${hasHdd ? 'supported' : 'not supported'})',
      'description': '',
      'supported': hasHdd ? 'true' : 'false',
    });

    return items;
  }
}

class _UpgradeItem extends StatelessWidget {
  final String label;
  final String description;
  final bool supported;

  const _UpgradeItem({
    required this.label,
    required this.description,
    required this.supported,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: supported
                  ? const Color(0xFFEAF8F1)
                  : const Color(0xFFFFF0F0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              supported
                  ? Icons.check_circle_outline_rounded
                  : Icons.cancel_outlined,
              size: 16,
              color: supported
                  ? const Color(0xFF4FB987)
                  : const Color(0xFFE97878),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColor.kTextPrimary.withValues(alpha: 0.84),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
