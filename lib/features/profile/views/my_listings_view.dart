import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:school_assgn/widget/text_widget.dart';

class MyListingsView extends GetView<ProfileController> {
  const MyListingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.kAuthTextPrimary,
            size: 18,
          ),
        ),
        title: AppText(
          'My Shop & Listings',
          variant: AppTextVariant.title,
          color: AppColor.kAuthTextPrimary,
          fontSize: 18,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_box_rounded,
              color: AppColor.kGoogleBlue,
              size: 26,
            ),
            onPressed: () => _showAddHardwareSheet(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshProfile,
        color: AppColor.kGoogleBlue,
        backgroundColor: AppColor.kSurface,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
        child: Obx(() {
          final hasShop = controller.shopId.value.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasShop) ...[
                // ── Shop Profile Card ──
                _buildShopProfileHeader(context),
                const SizedBox(height: 24),

                // ── Listings Section ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      'Active Listings',
                      variant: AppTextVariant.title,
                      color: AppColor.kAuthTextPrimary,
                      fontSize: 16,
                    ),
                    AppText(
                      '3 items',
                      variant: AppTextVariant.caption,
                      color: AppColor.kAuthTextSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Mock Listings (For now)
                _buildListingItem(
                  name: 'MSI Katana 15',
                  price: '\$1,150',
                  spec: 'i7-13620H • RTX 4050 • 16GB RAM',
                  status: 'In Stock',
                ),
                _buildListingItem(
                  name: 'ASUS ROG Zephyrus',
                  price: '\$1,899',
                  spec: 'Ryzen 9 • RTX 4070 • 32GB RAM',
                  status: 'Popular',
                ),
                _buildListingItem(
                  name: 'MacBook Air M2',
                  price: '\$949',
                  spec: '8-Core CPU • 10-Core GPU • 8GB',
                  status: 'Low Stock',
                  statusColor: AppColor.kGoogleYellow,
                ),
              ] else ...[
                // ── Create Shop Onboarding ──
                _buildEmptyShopState(context),
              ],
            ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildShopProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.kBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Premium Avatar (75x75) ---
              Obx(
                () => Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: AppColor.kGoogleBlue.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.kGoogleBlue.withValues(alpha: 0.1),
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: controller.shopImageUrl.value.isNotEmpty
                          ? NetworkImage(controller.shopImageUrl.value) as ImageProvider
                          : const AssetImage('assets/images/nu.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // --- Shop Title & Rating ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Obx(
                      () => AppText(
                        controller.shopName.value,
                        variant: AppTextVariant.title,
                        color: AppColor.kAuthTextPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: AppColor.kGoogleYellow,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        AppText(
                          '4.9',
                          variant: AppTextVariant.label,
                          color: AppColor.kAuthTextPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(width: 4),
                        AppText(
                          '| 987 reviews',
                          variant: AppTextVariant.caption,
                          color: AppColor.kAuthTextSecondary,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- Modern Edit Action ---
              IconButton(
                onPressed: () => _showEditShopSheet(context),
                style: IconButton.styleFrom(
                  backgroundColor: AppColor.kGoogleBlue.withValues(alpha: 0.1),
                  padding: const EdgeInsets.all(8),
                ),
                icon: Icon(
                  Icons.edit_rounded,
                  color: AppColor.kGoogleBlue,
                  size: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 16),

          // --- Detailed Shop Layout ---
          Column(
            children: [
              Obx(() => _buildHeaderInfo(Icons.location_on_rounded, controller.shopAddress.value)),
              const SizedBox(height: 10),
              Obx(() => _buildHeaderInfo(
                    Icons.map_rounded,
                    controller.shopGMapUrl.value,
                    onTap: () async {
                      final url = Uri.tryParse(controller.shopGMapUrl.value);
                      if (url != null && await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                    isLink: true,
                  )),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Obx(() => _buildHeaderInfo(Icons.phone_rounded, controller.shopPhone.value)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Obx(() => _buildHeaderInfo(Icons.telegram_rounded, '@${controller.shopTelegram.value.replaceAll('@', '')}')),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo(IconData icon, String text, {VoidCallback? onTap, bool isLink = false}) {
    if (text.isEmpty) return const SizedBox.shrink();
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: isLink ? AppColor.kGoogleBlue : AppColor.kAuthTextSecondary, size: 14),
          const SizedBox(width: 8),
          Flexible(
            child: AppText(
              text,
              variant: AppTextVariant.caption,
              color: isLink ? AppColor.kGoogleBlue : AppColor.kAuthTextSecondary,
              fontSize: 11,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              decoration: isLink ? TextDecoration.underline : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditShopSheet(BuildContext context) {
    _showShopFormSheet(context, isEditing: true);
  }

  void _showCreateShopSheet(BuildContext context) {
    controller.shopNameCtrl.clear();
    controller.shopPhoneCtrl.clear();
    controller.shopTelegramCtrl.clear();
    controller.shopProvinceCtrl.clear();
    controller.shopDistrictCtrl.clear();
    controller.shopAddrDetailCtrl.clear();
    controller.shopGMapUrlCtrl.clear();
    _showShopFormSheet(context, isEditing: false);
  }

  void _showShopFormSheet(BuildContext context, {required bool isEditing}) {
    if (isEditing) {
      controller.shopNameCtrl.text = controller.shopName.value;
      controller.shopPhoneCtrl.text = controller.shopPhone.value;
      controller.shopTelegramCtrl.text = controller.shopTelegram.value;
      controller.shopProvinceCtrl.text = controller.shopProvince.value;
      controller.shopDistrictCtrl.text = controller.shopDistrict.value;
      controller.shopAddrDetailCtrl.text = controller.shopAddrDetail.value;
      controller.shopGMapUrlCtrl.text = controller.shopGMapUrl.value;
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColor.kBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                isEditing ? 'Edit Shop Profile' : 'Register Your Shop',
                variant: AppTextVariant.title,
                fontSize: 20,
              ),
              const SizedBox(height: 16),

              // ── Image Picker ──
              GestureDetector(
                onTap: () => controller.pickShopImage(),
                child: Obx(() {
                  final localPath = controller.selectedShopImage.value;
                  final remoteUrl = controller.shopImageUrl.value;

                  return Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColor.kGoogleBlue.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.kGoogleBlue.withValues(alpha: 0.2),
                            width: 2,
                          ),
                          image: localPath != null
                              ? DecorationImage(
                                  image: FileImage(File(localPath)),
                                  fit: BoxFit.cover,
                                )
                              : remoteUrl.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(remoteUrl),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                        ),
                        child: (localPath == null && remoteUrl.isEmpty)
                            ? Icon(
                                Icons.add_a_photo_rounded,
                                color: AppColor.kGoogleBlue,
                                size: 30,
                              )
                            : null,
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColor.kGoogleBlue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 8),
              if (!isEditing)
                AppText(
                  'Start selling hardware by setting up your shop profile.',
                  variant: AppTextVariant.caption,
                  color: AppColor.kAuthTextSecondary,
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 24),
              _buildTextField(
                'Shop Name',
                hint: 'e.g. GTC Computer',
                controller: controller.shopNameCtrl,
              ),
              _buildTextField(
                'Province',
                hint: 'e.g. Phnom Penh',
                controller: controller.shopProvinceCtrl,
              ),
              _buildTextField(
                'District',
                hint: 'e.g. Dangkao',
                controller: controller.shopDistrictCtrl,
              ),
              _buildTextField(
                'Address Detail',
                hint: 'e.g. #123, St. 456',
                controller: controller.shopAddrDetailCtrl,
              ),
              _buildTextField(
                'Shop Phone',
                hint: 'e.g. 098 777 666',
                keyboardType: TextInputType.phone,
                controller: controller.shopPhoneCtrl,
              ),
              _buildTextField(
                'Telegram Handle',
                hint: 'e.g. @narak_shop',
                controller: controller.shopTelegramCtrl,
              ),
              _buildTextField(
                'Google Maps URL',
                hint: 'e.g. https://maps.app.goo.gl/...',
                controller: controller.shopGMapUrlCtrl,
                suffixIcon: Obx(() => controller.isLocationLoading.value
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: LoadingAnimationWidget.discreteCircle(
                          color: AppColor.kGoogleBlue,
                          secondRingColor: AppColor.kGoogleRed,
                          thirdRingColor: AppColor.kGoogleYellow,
                          size: 20,
                        ),
                      )
                    : IconButton(
                        onPressed: () => controller.getCurrentLocation(),
                        icon: Icon(
                          Icons.my_location_rounded,
                          color: AppColor.kGoogleBlue,
                          size: 20,
                        ),
                      )),
              ),
              const SizedBox(height: 32),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.isShopUpdating.value
                        ? null
                        : () async {
                            if (isEditing) {
                              await controller.updateShopProfile();
                            } else {
                              await controller.createShopProfile();
                            }
                            Get.back();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.kGoogleBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: controller.isShopUpdating.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : AppText(
                            isEditing ? 'Save Changes' : 'Create My Shop',
                            variant: AppTextVariant.title,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildEmptyShopState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColor.kAuthSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.kAuthBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.kGoogleBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.storefront_rounded,
              color: AppColor.kGoogleBlue,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          const AppText(
            'Ready to Sell?',
            variant: AppTextVariant.title,
            fontSize: 20,
          ),
          const SizedBox(height: 8),
          AppText(
            'You have technical permission! Create your shop profile now to start posting hardware listings.',
            variant: AppTextVariant.body,
            color: AppColor.kAuthTextSecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => _showCreateShopSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.kGoogleBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const AppText(
                'Create Shop Now',
                variant: AppTextVariant.title,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopStat(String label, String value) {
    return Column(
      children: [
        AppText(
          value,
          variant: AppTextVariant.title,
          color: AppColor.kAuthTextPrimary,
          fontSize: 16,
        ),
        const SizedBox(height: 2),
        AppText(
          label,
          variant: AppTextVariant.caption,
          color: AppColor.kAuthTextSecondary,
          fontSize: 11,
        ),
      ],
    );
  }

  Widget _buildListingItem({
    required String name,
    required String price,
    required String spec,
    required String status,
    Color statusColor = AppColor.kGoogleGreen,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.kAuthSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/laptop.png",
            height: 34,
            color: AppColor.kAccent,
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(name, variant: AppTextVariant.title, fontSize: 15),
                    AppText(
                      price,
                      variant: AppTextVariant.title,
                      color: AppColor.kGoogleBlue,
                      fontSize: 15,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                AppText(
                  spec,
                  variant: AppTextVariant.caption,
                  color: AppColor.kAuthTextSecondary,
                  fontSize: 12,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AppText(
                    status,
                    variant: AppTextVariant.body,
                    color: statusColor,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddHardwareSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppColor.kBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle Bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.kAuthTextSecondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText(
                  'Post New Hardware',
                  variant: AppTextVariant.title,
                  fontSize: 20,
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Basic Info ──
                    _buildFormSectionLabel('Basic Information'),
                    _buildTextField(
                      'Brand & Model Name',
                      hint: 'e.g. MSI Cyborg 15 A12V',
                    ),
                    _buildTextField(
                      'Price (\$)',
                      hint: 'e.g. 1050',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),

                    // ── Performance Specs ──
                    _buildFormSectionLabel('Performance Specs'),
                    _buildTextField(
                      'CPU Model',
                      hint: 'e.g. Intel Core i7-12650H',
                    ),
                    _buildTextField(
                      'GPU Model',
                      hint: 'e.g. NVIDIA RTX 4060 8GB',
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'RAM Size (GB)',
                            hint: '16',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField('RAM Type', hint: 'DDR5'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'RAM Slots',
                            hint: '2',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            'Max RAM (GB)',
                            hint: '64',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Storage Specs ──
                    _buildFormSectionLabel('Storage Specs'),
                    _buildTextField(
                      'SSD/HDD Capacity',
                      hint: 'e.g. 512GB NVMe',
                    ),
                    _buildTextField('SSD Interface', hint: 'e.g. PCIe Gen4 x4'),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'SSD Form Factor',
                            hint: 'M.2 2280',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField('HDD Bay?', hint: 'No'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Display Specs ──
                    _buildFormSectionLabel('Display Specs'),
                    _buildTextField('Screen Size', hint: 'e.g. 15.6" Full HD'),
                    _buildTextField('Resolution', hint: 'e.g. 1920 x 1080'),
                    _buildTextField('Refresh Rate', hint: 'e.g. 144Hz'),

                    const SizedBox(height: 40),

                    // ── Post Button ──
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          Get.snackbar(
                            'Success',
                            'Your hardware listing has been posted!',
                            backgroundColor: AppColor.kGoogleGreen,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.kGoogleBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const AppText(
                          'Post Hardware Listing',
                          variant: AppTextVariant.title,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildFormSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppText(
        label,
        variant: AppTextVariant.title,
        color: AppColor.kGoogleBlue,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    String? hint,
    TextInputType? keyboardType,
    TextEditingController? controller,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          variant: AppTextVariant.caption,
          color: AppColor.kAuthTextSecondary,
          fontSize: 12,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller, // Added controller
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColor.kAuthTextSecondary.withValues(alpha: 0.4),
              fontSize: 13,
            ),
            filled: true,
            fillColor: AppColor.kAuthSurface,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.03)),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
