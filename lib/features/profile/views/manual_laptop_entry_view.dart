import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class ManualLaptopEntryView extends GetView<ProfileController> {
  const ManualLaptopEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackground,
      appBar: AppBar(
        backgroundColor: AppColor.kBackground,
        elevation: 0,
        centerTitle: true,
        title: const AppText(
          'Manual Laptop Entry',
          variant: AppTextVariant.title,
          fontSize: 18,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Basic Identity',
              children: [
                _buildBrandSelector(),
                const SizedBox(height: 16),
                _buildSearchableModelField(),
                _buildCpuBrandSelector(),
                _buildField(
                  label: 'CPU Model Name',
                  hint: 'e.g. Core i7-12700H / Ryzen 7 5800H',
                  controller: controller.manualCpuCtrl,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'Memory (RAM)',
              children: [
                _buildChoiceSelector(
                  label: 'RAM Type',
                  options: ['DDR3', 'DDR4', 'DDR5'],
                  selectedRx: controller.manualRamType,
                ),
                _buildChoiceSelector(
                  label: 'RAM Slots',
                  options: ['1', '2', '3'],
                  selectedRx: controller.manualRamSlots,
                ),
                _buildChoiceSelector(
                  label: 'Base RAM (GB)',
                  options: ['2', '4', '8', '16', '32', '64'],
                  selectedRx: controller.manualRamBase,
                ),
                _buildChoiceSelector(
                  label: 'Max Support (GB)',
                  options: ['16', '32', '64', '128'],
                  selectedRx: controller.manualMaxRam,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'Storage & Display',
              children: [
                _buildChoiceSelector(
                  label: 'SSD Slots',
                  options: ['1', '2', '3', '4'],
                  selectedRx: controller.manualSsdSlots,
                ),
                _buildChoiceSelector(
                  label: 'SSD Interface',
                  options: ['SATA', 'Pcie/NVMe', 'mSATA'],
                  selectedRx: controller.manualSsdInterface,
                ),
                _buildChoiceSelector(
                  label: 'Additional HDD Bay',
                  options: ['Yes', 'No'],
                  selectedRx: controller.manualAddHdd,
                ),
                const SizedBox(height: 8),
                _buildChoiceSelector(
                  label: 'Display Size Range',
                  options: [
                    '10.9" & Under',
                    '11" - 11.9"',
                    '12" - 12.9"',
                    '13" - 13.9"',
                    '14" - 14.9"',
                    '15" - 15.9"',
                    '16" - 16.9"',
                    '17" & Larger',
                  ],
                  selectedRx: controller.manualDisplaySizeRange,
                ),
                _buildField(
                  label: 'Exact Resolution',
                  hint: 'e.g. 1920x1080',
                  controller: controller.manualDisplayResCtrl,
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isSavingManualLaptop.value
                      ? null
                      : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.kGoogleBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isSavingManualLaptop.value
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const AppText(
                          'Save Laptop to Profile',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSave() {
    // Proceed to save
    controller.saveManualLaptop();
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.kGoogleBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.kGoogleBlue.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColor.kGoogleBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.psychology_rounded, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const AppText(
            'Custom Hardware Profile',
            variant: AppTextVariant.title,
            fontSize: 16,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          AppText(
            'Create a custom record for your unique laptop model to track compatibility.',
            variant: AppTextVariant.caption,
            color: AppColor.kAuthTextSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: AppText(
            title,
            variant: AppTextVariant.title,
            fontSize: 15,
            color: AppColor.kAuthTextPrimary,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.kAuthSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.kAuthBorder),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildBrandSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Laptop Brand',
          variant: AppTextVariant.caption,
          color: AppColor.kAuthTextSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.laptopBrands.isEmpty) {
            return _buildField(
              label: 'Brand',
              hint: 'e.g. ASUS / Lenovo',
              controller: controller.manualBrandCtrl,
            );
          }
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.laptopBrands.map((brand) {
              final brandId = brand['id']?.toString() ?? '';
              final isSelected = controller.manualBrandId.value == brandId;
              return ChoiceChip(
                label: AppText(
                  brand['name'] ?? 'N/A',
                  variant: AppTextVariant.caption,
                  color: isSelected ? Colors.white : AppColor.kAuthTextPrimary,
                  fontSize: 12,
                ),
                selected: isSelected,
                selectedColor: AppColor.kGoogleBlue,
                backgroundColor: AppColor.kAuthSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSelected
                        ? AppColor.kGoogleBlue
                        : AppColor.kAuthBorder,
                  ),
                ),
                showCheckmark: false,
                onSelected: (selected) {
                  if (selected) {
                    final brandId = brand['id']?.toString() ?? '';
                    controller.manualBrandCtrl.text = brand['name'] ?? '';
                    controller.manualBrandId.value = brandId;
                    // Pre-fetch models for advanced search suggestions
                    controller.fetchModelsForBrand(brandId);
                  }
                },
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildCpuBrandSelector() {
    final cpuBrands = ['Intel', 'AMD', 'Xeon', 'Other'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'CPU Brand',
            variant: AppTextVariant.caption,
            color: AppColor.kAuthTextSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          Obx(
            () => Row(
              children: cpuBrands.map((b) {
                final isSelected = controller.manualCpuBrand.value == b;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => controller.manualCpuBrand.value = b,
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColor.kGoogleBlue
                            : AppColor.kAuthSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColor.kGoogleBlue
                              : AppColor.kAuthBorder,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: AppText(
                        b,
                        variant: AppTextVariant.caption,
                        color: isSelected
                            ? Colors.white
                            : AppColor.kAuthTextPrimary,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : null,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchableModelField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildField(
          label: 'Model Name',
          hint: 'e.g. ROG Strix G15',
          controller: controller.manualModelCtrl,
        ),
        Obx(() {
          if (controller.filteredManualModels.isEmpty) {
            return const SizedBox.shrink();
          }
          return Container(
            margin: const EdgeInsets.only(top: 4, bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColor.kAuthSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.kAuthBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: AppText(
                    'Suggestions from our system:',
                    variant: AppTextVariant.caption,
                    fontSize: 10,
                    color: AppColor.kGoogleBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ...controller.filteredManualModels.map(
                  (m) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    title: AppText(
                      m['name'] ?? '',
                      variant: AppTextVariant.caption,
                      fontSize: 13,
                    ),
                    onTap: () {
                      controller.manualModelCtrl.text = m['name'] ?? '';
                      controller.filteredManualModels.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildChoiceSelector({
    required String label,
    required List<String> options,
    required RxString selectedRx,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            label,
            variant: AppTextVariant.caption,
            color: AppColor.kAuthTextSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((opt) {
                final isSelected = selectedRx.value == opt;
                return GestureDetector(
                  onTap: () => selectedRx.value = opt,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.kGoogleBlue
                          : AppColor.kAuthSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColor.kGoogleBlue
                            : AppColor.kAuthBorder,
                      ),
                    ),
                    child: AppText(
                      opt,
                      variant: AppTextVariant.caption,
                      color: isSelected
                          ? Colors.white
                          : AppColor.kAuthTextPrimary,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            label,
            variant: AppTextVariant.caption,
            color: AppColor.kAuthTextSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColor.kAuthTextSecondary.withValues(alpha: 0.5),
                fontSize: 13,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColor.kAuthBorder),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColor.kGoogleBlue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
