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

      // ── Build upgrade items from spec 
      final items = _buildUpgradeItems(spec);

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.kSurface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColor.kSurface.withValues(alpha: 0.12),
            width: AppColor.kBorderWidth,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================Title===========================
            AppText(
              'What can your $modelName upgrade?',
              variant: AppTextVariant.title,
              color: AppColor.kTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),

            const SizedBox(height: 16),

            // ── Upgrade items 
            ...items.map(
              (item) => _UpgradeItem(
                label: item['label']!,
                description: item['description']!,
                supported: item['supported'] == 'true',
              ),
            ),

            const SizedBox(height: 16),

            // ================BUtton=======================================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: navigate to compatible parts
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.kGoogleBlue.withValues(alpha: 0.6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppColor.kCardRadius),
                  ),
                  elevation: 0,
                ),
                child: AppText(
                  'Find Compatible Parts', 
                  variant: AppTextVariant.body,
                  color: AppColor.kAuthAccent,
                  fontSize: 15,
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

    // ===========================Ram===============================================
    final ramSlots  = int.tryParse(spec['ram_slots']?.toString() ?? '0') ?? 0;
    final maxRam    = spec['max_ram_gg']?.toString() ?? '';
    final ramType   = spec['ram_type']?.toString() ?? '';

    if (ramSlots == 0) {
      items.add({
        'label'      : 'RAM soldered (check first version)',
        'description': '',
        'supported'  : 'false',
      });
    } else {
      items.add({
        'label'      : 'RAM (up to ${maxRam}GB $ramType)',
        'description': '',
        'supported'  : 'true',
      });
    }

    //================SSD============================================================
    final ssdSlots    = int.tryParse(spec['ssd_slots']?.toString() ?? '0') ?? 0;
    final ssdIface    = spec['ssd_interface']?.toString() ?? 'NVMe';
    final ssdFactor   = spec['ssd_from_factor']?.toString() ?? 'M.2';

    if (ssdSlots > 0) {
      items.add({
        'label'      : '$ssdFactor $ssdIface SSD ($ssdSlots slot${ssdSlots > 1 ? 's' : ''} available)',
        'description': '',
        'supported'  : 'true',
      });
    } else {
      items.add({
        'label'      : 'SSD (no slot available)',
        'description': '',
        'supported'  : 'false',
      });
    }

    // =================HHD Bay =============================================================
    final hasHdd = spec['has_hdd_bay'] == true;
    items.add({
      'label'    : 'HDD Bay (${hasHdd ? 'supported' : 'not supported'})',
      'description': '',
      'supported': hasHdd ? 'true' : 'false',
    });

    return items;
  }
}

// ==============================Single upgrade item row==================================== 

class _UpgradeItem extends StatelessWidget {
  final String label;
  final String description;
  final bool   supported;

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
          // ── Icon 
          Icon(
            supported
                ? Icons.check_circle_outline_rounded
                : Icons.cancel_outlined,
            size : 20,
            color: supported
                ? const Color(0xFF22C55E)   // green
                : const Color(0xFFEF4444),  // red
          ),
          const SizedBox(width: 10),

          // ── Label 
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize  : 13,
                fontWeight: FontWeight.w400,
                color     : AppColor.kTextPrimary.withValues(alpha: 0.82),
                height    : 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
