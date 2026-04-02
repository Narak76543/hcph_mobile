import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/home/controllers/home_controller.dart';
import 'package:school_assgn/features/home/models/home_models.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/input_field.dart';
import 'package:school_assgn/widget/text_widget.dart';

class PostHardwareView extends GetView<ProfileController> {
  final PostModel? editingPost;

  const PostHardwareView({super.key, this.editingPost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackground,
      appBar: AppBar(
        backgroundColor: AppColor.kBackground,
        elevation: 0,
        centerTitle: true,
        title: AppText(
          editingPost != null ? 'Edit Hardware' : 'Technician Hardware Post',
          variant: AppTextVariant.title,
          fontSize: 18,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: Obx(() {
        final hasCategory =
            controller.selectedCategoryIdForPost.value.isNotEmpty;
        final category = controller.selectedPostCategory;
        final canPost = hasCategory && !controller.isPostingHardware.value;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroHeader(category, hasCategory: hasCategory),
              const SizedBox(height: 20),
              _buildSectionCard(
                title: 'Part Category',
                subtitle:
                    'Choose the hardware type first. The form below will build the matching `part_specs` payload automatically.',
                child: _buildCategorySelector(),
              ),
              const SizedBox(height: 16),
              if (!hasCategory)
                _buildSectionCard(
                  title: 'Step 1 Required',
                  subtitle:
                      'Select a category before entering brand, model, price, or specs.',
                  child: _buildEmptyState(
                    icon: Icons.category_outlined,
                    title: 'Choose the hardware category first',
                    subtitle:
                        'After you pick RAM, SSD, Battery, Display, or another part type, the posting form will open below.',
                  ),
                )
              else ...[
                _buildSectionCard(
                  title: 'Catalog Basics',
                  subtitle:
                      'Separate brand, model, and price so the backend gets cleaner inventory data.',
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Brand',
                              hint: 'e.g. Samsung',
                              controller: controller.hardwareBrandCtrl,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              'Model Name',
                              hint: 'e.g. 990 PRO 1TB',
                              controller: controller.hardwareModelCtrl,
                            ),
                          ),
                        ],
                      ),
                      _buildTextField(
                        'Price (USD)',
                        hint: 'e.g. 129.99',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: controller.hardwarePriceCtrl,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Hardware Photo',
                  subtitle:
                      'Upload a clean product image. This still works even if your backend prefers multipart form uploads.',
                  child: _buildImagePicker(),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Technical Specs',
                  subtitle:
                      'Fill only the fields that apply to ${category.name}.',
                  child: _buildTechnicalSpecEditor(
                    category,
                    hasCategory: hasCategory,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  title: 'Posting Preview',
                  subtitle:
                      'The app will send a structured `part_specs` object plus a readable summary for older endpoints.',
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildInfoChip(
                        icon: Icons.category_rounded,
                        label: category.name,
                      ),
                      _buildInfoChip(
                        icon: Icons.storefront_rounded,
                        label: controller.shopName.value.isNotEmpty
                            ? controller.shopName.value
                            : 'Shop profile required',
                      ),
                      _buildInfoChip(
                        icon: controller.selectedHardwareImage.value != null
                            ? Icons.check_circle_rounded
                            : Icons.add_a_photo_rounded,
                        label: controller.selectedHardwareImage.value != null
                            ? 'Photo attached'
                            : 'Photo optional',
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: canPost ? controller.postHardwareListing : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.kGoogleBlue,
                    disabledBackgroundColor: AppColor.kGoogleBlue.withValues(
                      alpha: 0.55,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isPostingHardware.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.2,
                          ),
                        )
                      : AppText(
                          hasCategory
                              ? 'Post Hardware Listing'
                              : 'Select Category First',
                          color: Colors.white,
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeroHeader(CategoryModel category, {required bool hasCategory}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [AppColor.kGoogleBlue, AppColor.kAccentDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.kGoogleBlue.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const AppText(
              'Technician Console',
              variant: AppTextVariant.caption,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          const AppText(
            'Create a hardware listing with structured specs.',
            variant: AppTextVariant.title,
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 8),
          AppText(
            hasCategory
                ? 'Currently configuring ${category.name}. The form will adapt to the selected part type.'
                : 'Start by choosing the part category, then enter the exact technical details for that item.',
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 13,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    final homeCtrl = Get.find<HomeController>();
    final categories = homeCtrl.categories
        .where((c) => c.slug != 'all')
        .toList();
    final selectedId = controller.selectedCategoryIdForPost.value;

    if (categories.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.kBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.kBorder),
        ),
        child: const AppText(
          'Categories are still loading from the backend.',
          fontSize: 13,
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((cat) {
        final isSelected = selectedId == cat.id;
        return InkWell(
          onTap: () => controller.selectedCategoryIdForPost.value = cat.id,
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColor.kGoogleBlue : AppColor.kSurface,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: isSelected
                    ? AppColor.kGoogleBlue
                    : AppColor.kBorder.withValues(alpha: 0.8),
                width: 1.3,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCategoryIcon(cat, isSelected: isSelected),
                const SizedBox(width: 10),
                AppText(
                  cat.name,
                  variant: AppTextVariant.label,
                  color: isSelected ? Colors.white : AppColor.kTextPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryIcon(
    CategoryModel category, {
    required bool isSelected,
  }) {
    final fallbackColor = isSelected ? Colors.white : AppColor.kGoogleBlue;

    if (category.imageUrl != null && category.imageUrl!.isNotEmpty) {
      return Image.network(
        category.imageUrl!,
        width: 20,
        height: 20,
        color: isSelected ? Colors.white : null,
        errorBuilder: (_, _, _) => Icon(
          category.icon ?? Icons.memory_rounded,
          size: 20,
          color: fallbackColor,
        ),
      );
    }

    return Icon(
      category.icon ?? Icons.memory_rounded,
      size: 20,
      color: fallbackColor,
    );
  }

  Widget _buildTechnicalSpecEditor(
    CategoryModel category, {
    required bool hasCategory,
  }) {
    if (!hasCategory) {
      return _buildEmptyState(
        icon: Icons.developer_board_rounded,
        title: 'No category selected yet',
        subtitle:
            'Choose a part category above and the correct spec editor will appear here.',
      );
    }

    final sections = <Widget>[];

    if (controller.categoryMatches(category, ['cpu', 'gpu', 'motherboard'])) {
      sections.add(
        _buildSubSection(
          'Performance Specs',
          'Useful for boards, chipsets, and high-performance parts.',
          [
            _buildTextField(
              'CPU Model',
              hint: 'e.g. Intel Core i7-13620H',
              controller: controller.hardwareCpuCtrl,
            ),
            _buildTextField(
              'GPU Model',
              hint: 'e.g. NVIDIA RTX 4060 8GB',
              controller: controller.hardwareGpuCtrl,
            ),
          ],
        ),
      );
    }

    if (controller.categoryMatches(category, ['ram', 'memory'])) {
      sections.add(
        _buildSubSection(
          'Memory Specs',
          'These fields map directly into the structured RAM `part_specs` object.',
          [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Capacity (GB)',
                    hint: '8, 16, 32',
                    keyboardType: TextInputType.number,
                    controller: controller.hardwareRamCapacityGbCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownField(
                    'RAM Type',
                    items: const ['DDR4', 'DDR5', 'LPDDR4X', 'LPDDR5'],
                    controller: controller.hardwareRamTypeCtrl,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Bus (MHz)',
                    hint: '3200, 4800',
                    keyboardType: TextInputType.number,
                    controller: controller.hardwareRamBusMhzCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownField(
                    'Form Factor',
                    items: const ['DIMM', 'SO-DIMM'],
                    controller: controller.hardwareRamFormFactorCtrl,
                  ),
                ),
              ],
            ),
            _buildTextField(
              'Latency',
              hint: 'e.g. CL16 or CL40',
              controller: controller.hardwareRamLatencyCtrl,
            ),
          ],
        ),
      );
    }

    if (controller.categoryMatches(category, ['ssd'])) {
      sections.add(
        _buildSubSection(
          'SSD Specs',
          'Use standardized interface and form-factor values for cleaner inventory filtering.',
          [
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    'SSD Type',
                    items: const ['NVMe', 'SATA'],
                    controller: controller.hardwareSsdTypeCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    'Capacity (GB)',
                    hint: '256, 512, 1000',
                    keyboardType: TextInputType.number,
                    controller: controller.hardwareSsdCapacityGbCtrl,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    'Form Factor',
                    items: const ['M.2 2280', 'M.2 2242', '2.5"'],
                    controller: controller.hardwareSsdFormFactorCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownField(
                    'Interface',
                    items: const [
                      'PCIe 3.0',
                      'PCIe 4.0',
                      'PCIe 5.0',
                      'SATA III',
                    ],
                    controller: controller.hardwareSsdInterfaceCtrl,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Read Speed (MB/s)',
                    hint: 'e.g. 3500',
                    keyboardType: TextInputType.number,
                    controller: controller.hardwareSsdReadSpeedCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    'Write Speed (MB/s)',
                    hint: 'e.g. 3000',
                    keyboardType: TextInputType.number,
                    controller: controller.hardwareSsdWriteSpeedCtrl,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (controller.categoryMatches(category, ['hdd', 'hhd'])) {
      sections.add(
        _buildSubSection(
          'HDD Specs',
          'Good for service shops that still post mechanical drives and legacy stock.',
          [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Capacity (GB)',
                    hint: '1000, 2000, 4000',
                    keyboardType: TextInputType.number,
                    controller: controller.hardwareHddCapacityGbCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    'RPM',
                    hint: '5400, 7200',
                    keyboardType: TextInputType.number,
                    controller: controller.hardwareHddRpmCtrl,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    'Form Factor',
                    items: const ['2.5"', '3.5"'],
                    controller: controller.hardwareHddFormFactorCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    'Cache (MB)',
                    hint: '64, 128, 256',
                    keyboardType: TextInputType.number,
                    controller: controller.hardwareHddCacheMbCtrl,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (controller.categoryMatches(category, ['battery'])) {
      sections.add(
        _buildSubSection(
          'Battery Specs',
          'Capture both capacity and connector info for repair-focused listings.',
          [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Capacity (Wh)',
                    hint: 'e.g. 52.5',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    controller: controller.hardwareBatteryWhCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    'Capacity (mAh)',
                    hint: 'e.g. 4500',
                    keyboardType: TextInputType.number,
                    controller: controller.hardwareBatteryMahCtrl,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Cells',
                    hint: '3, 4, 6',
                    keyboardType: TextInputType.number,
                    controller: controller.hardwareBatteryCellsCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    'Voltage (V)',
                    hint: 'e.g. 15.2',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    controller: controller.hardwareBatteryVoltageCtrl,
                  ),
                ),
              ],
            ),
            _buildDropdownField(
              'Battery Type',
              items: const ['Li-ion', 'Li-polymer'],
              controller: controller.hardwareBatteryTypeCtrl,
            ),
            _buildTextField(
              'Connector Type',
              hint: 'e.g. 10-pin internal',
              controller: controller.hardwareBatteryConnectorCtrl,
            ),
          ],
        ),
      );
    }

    if (controller.categoryMatches(category, ['charger', 'adapter'])) {
      sections.add(
        _buildSubSection(
          'Charger Specs',
          'Ideal for adapter listings where voltage and connector compatibility matter.',
          [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Wattage (W)',
                    hint: '45, 65, 120, 240',
                    keyboardType: TextInputType.number,
                    controller: controller.hardwareChargerWattageCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    'Voltage (V)',
                    hint: '19 or 20',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    controller: controller.hardwareChargerVoltageCtrl,
                  ),
                ),
              ],
            ),
            _buildDropdownField(
              'Connector Type',
              items: const ['USB-C', 'Barrel', 'Proprietary'],
              controller: controller.hardwareChargerConnectorCtrl,
            ),
            _buildDropdownField(
              'Standard',
              items: const ['GaN', 'Traditional'],
              controller: controller.hardwareChargerStandardCtrl,
            ),
          ],
        ),
      );
    }

    if (controller.categoryMatches(category, ['fan', 'cooling'])) {
      sections.add(
        _buildSubSection(
          'Cooling Fan Specs',
          'Useful when you need repair-grade details like pin count and max RPM.',
          [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Size (mm)',
                    hint: '40, 60, 80',
                    keyboardType: TextInputType.number,
                    controller: controller.hardwareFanSizeMmCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownField(
                    'Connector',
                    items: const ['3-pin', '4-pin'],
                    controller: controller.hardwareFanConnectorCtrl,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Max RPM',
                    hint: 'e.g. 2500',
                    keyboardType: TextInputType.number,
                    controller: controller.hardwareFanMaxRpmCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownField(
                    'Fan Type',
                    items: const ['CPU', 'GPU', 'Laptop'],
                    controller: controller.hardwareFanTypeCtrl,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (controller.categoryMatches(category, [
      'screen',
      'display',
      'monitor',
    ])) {
      sections.add(
        _buildSubSection(
          'Display Specs',
          'Capture panel details and brightness so buyers can compare replacement screens quickly.',
          [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Size (Inch)',
                    hint: 'e.g. 15.6',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    controller: controller.hardwareDisplaySizeInchCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    'Resolution',
                    hint: 'e.g. 1920x1080',
                    controller: controller.hardwareDisplayResolutionCtrl,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Refresh Rate (Hz)',
                    hint: '60, 144, 240',
                    keyboardType: TextInputType.number,
                    controller: controller.hardwareDisplayRefreshRateCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownField(
                    'Panel Type',
                    items: const ['IPS', 'TN', 'VA', 'OLED'],
                    controller: controller.hardwareDisplayPanelTypeCtrl,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Connector Pin',
                    hint: 'e.g. eDP 30-pin',
                    controller: controller.hardwareDisplayConnectorPinCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    'Brightness (nits)',
                    hint: 'e.g. 300',
                    keyboardType: TextInputType.number,
                    controller: controller.hardwareDisplayBrightnessNitCtrl,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (controller.categoryMatches(category, ['thermal', 'paste'])) {
      sections.add(
        _buildSubSection(
          'Thermal Specs',
          'Use this for thermal paste or cooling compounds where conductivity matters.',
          [
            _buildTextField(
              'Conductivity (W/mK)',
              hint: 'e.g. 8.5',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              controller: controller.hardwareThermalConductivityCtrl,
            ),
            _buildDropdownField(
              'Thermal Type',
              items: const ['Metal', 'Ceramic', 'Carbon'],
              controller: controller.hardwareThermalTypeCtrl,
            ),
            _buildTextField(
              'Weight (g)',
              hint: 'e.g. 2',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              controller: controller.hardwareThermalWeightCtrl,
            ),
          ],
        ),
      );
    }

    if (sections.isEmpty) {
      return _buildEmptyState(
        icon: Icons.rule_folder_rounded,
        title: 'No custom technical fields for this category',
        subtitle:
            'The listing can still be posted with brand, model, price, and image. Add a dedicated spec card later if this category needs one.',
      );
    }

    return Column(
      children:
          sections
              .expand((section) => [section, const SizedBox(height: 14)])
              .toList()
            ..removeLast(),
    );
  }

  Widget _buildSubSection(
    String title,
    String subtitle,
    List<Widget> children,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.kBackground.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColor.kBorder.withValues(alpha: 0.85)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            variant: AppTextVariant.label,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          const SizedBox(height: 4),
          AppText(
            subtitle,
            variant: AppTextVariant.caption,
            fontSize: 12,
            color: AppColor.kTextSecondary,
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: controller.pickHardwareImage,
      child: Obx(() {
        final path = controller.selectedHardwareImage.value;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          height: 210,
          decoration: BoxDecoration(
            color: AppColor.kBackground.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: path == null
                  ? AppColor.kBorder.withValues(alpha: 0.9)
                  : AppColor.kGoogleBlue.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: path == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColor.kGoogleBlue.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_photo_alternate_rounded,
                        size: 34,
                        color: AppColor.kGoogleBlue,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const AppText(
                      'Tap to upload hardware photo',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      'Clean front-facing product shots work best for shop listings.',
                      variant: AppTextVariant.caption,
                      fontSize: 12,
                      color: AppColor.kTextSecondary,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(File(path), fit: BoxFit.cover),
                      Positioned(
                        right: 12,
                        top: 12,
                        child: GestureDetector(
                          onTap: () =>
                              controller.selectedHardwareImage.value = null,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const AppText(
                            'Tap the image again to replace it.',
                            variant: AppTextVariant.caption,
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColor.kSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.kBorder.withValues(alpha: 0.9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            variant: AppTextVariant.title,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 6),
          AppText(
            subtitle,
            variant: AppTextVariant.caption,
            fontSize: 12,
            color: AppColor.kTextSecondary,
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.kBackground,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColor.kBorder.withValues(alpha: 0.9)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColor.kGoogleBlue),
          const SizedBox(width: 8),
          AppText(
            label,
            variant: AppTextVariant.caption,
            color: AppColor.kTextPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.kBackground.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColor.kBorder.withValues(alpha: 0.9)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: AppColor.kGoogleBlue),
          const SizedBox(height: 10),
          AppText(
            title,
            variant: AppTextVariant.label,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          AppText(
            subtitle,
            variant: AppTextVariant.caption,
            fontSize: 12,
            color: AppColor.kTextSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    String? hint,
    TextInputType? keyboardType,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppInputField(
        controller: controller,
        label: label,
        hint: hint ?? label,
        keyboardType: keyboardType,
        labelAsHint: true,
      ),
    );
  }

  Widget _buildDropdownField(
    String label, {
    required List<String> items,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColor.kSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColor.kBorder.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              final currentValue = items.contains(value.text)
                  ? value.text
                  : null;

              return DropdownButton<String>(
                value: currentValue,
                hint: Text(
                  label,
                  style: TextStyle(
                    color: AppColor.kTextSecondary.withOpacity(0.6),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
                isExpanded: true,
                onChanged: (newValue) {
                  if (newValue != null) controller.text = newValue;
                },
                items: items
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.kTextPrimary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
