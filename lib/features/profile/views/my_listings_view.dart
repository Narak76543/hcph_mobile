import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:school_assgn/features/home/models/home_models.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';
import 'package:school_assgn/features/profile/views/post_hardware_view.dart';
import 'package:school_assgn/themes/app_color.dart';
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
            icon: Icon(Icons.add, color: AppColor.kGoogleBlue, size: 26),
            onPressed: () {
              controller.selectedCategoryIdForPost.value = '';
              Get.to(() => const PostHardwareView());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
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
                      '${controller.myListings.length} items',
                      variant: AppTextVariant.caption,
                      color: AppColor.kAuthTextSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (controller.isListingsLoading.value)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Center(
                      child: LoadingAnimationWidget.discreteCircle(
                        color: AppColor.kGoogleBlue,
                        secondRingColor: AppColor.kGoogleRed,
                        thirdRingColor: AppColor.kGoogleYellow,
                        size: 28,
                      ),
                    ),
                  )
                else if (controller.myListings.isEmpty)
                  _buildEmptyListingsState()
                else
                  ...controller.myListings.map(
                    (listing) => _buildListingItem(listing),
                  ),
              ] else ...[
                // ── Create Shop Onboarding ──
                _buildEmptyShopState(context),
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget _buildShopProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.kBackground,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColor.kGoogleBlue.withOpacity(0.1),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: controller.shopImageUrl.value.isNotEmpty
                      ? NetworkImage(controller.shopImageUrl.value)
                            as ImageProvider
                      : const AssetImage('assets/images/nu.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => AppText(
                    controller.shopName.value,
                    variant: AppTextVariant.body,
                    color: AppColor.kAuthTextPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: AppColor.kGoogleYellow,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    AppText(
                      '4.9 | 987 reviewed',
                      variant: AppTextVariant.caption,
                      color: AppColor.kAuthTextSecondary,
                      fontSize: 11,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(
                  () => _buildHeaderInfo(
                    Icons.location_on_rounded,
                    controller.shopAddress.value,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Obx(
                        () => _buildHeaderInfo(
                          Icons.phone_rounded,
                          controller.shopPhone.value,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 3,
                      child: Obx(
                        () => _buildHeaderInfo(
                          Icons.telegram_rounded,
                          controller.shopTelegram.value,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _showEditShopSheet(context),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColor.kGoogleBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const AppText(
                'Edit Shop',
                variant: AppTextVariant.body,
                color: AppColor.kGoogleBlue,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo(IconData icon, String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColor.kAuthTextSecondary, size: 14),
        const SizedBox(width: 4),
        Flexible(
          child: AppText(
            text,
            variant: AppTextVariant.caption,
            color: AppColor.kAuthTextSecondary,
            fontSize: 11,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
                          color: AppColor.kGoogleBlue.withOpacity(0.05),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.kGoogleBlue.withOpacity(0.2),
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
                              color: Colors.black.withOpacity(0.1),
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
                suffixIcon: Obx(
                  () => controller.isLocationLoading.value
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
                        ),
                ),
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
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.kAuthBorder.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.kGoogleBlue.withOpacity(0.1),
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

  // Widget _buildShopStat(String label, String value) {
  //   return Column(
  //     children: [
  //       AppText(
  //         value,
  //         variant: AppTextVariant.title,
  //         color: AppColor.kAuthTextPrimary,
  //         fontSize: 16,
  //       ),
  //       const SizedBox(height: 2),
  //       AppText(
  //         label,
  //         variant: AppTextVariant.caption,
  //         color: AppColor.kAuthTextSecondary,
  //         fontSize: 11,
  //       ),
  //     ],
  //   );
  // }

  Widget _buildEmptyListingsState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.kAuthSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.kAuthBorder.withOpacity(0.35)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 34,
            color: AppColor.kGoogleBlue,
          ),
          const SizedBox(height: 12),
          const AppText(
            'No listings yet',
            variant: AppTextVariant.title,
            fontSize: 16,
          ),
          const SizedBox(height: 6),
          AppText(
            'Tap the + button, select a category first, then post the hardware with its own image.',
            variant: AppTextVariant.caption,
            color: AppColor.kAuthTextSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildListingItem(PostModel listing) {
    final status = listing.isVerified ? 'Live' : 'Pending';
    final statusColor = listing.isVerified
        ? AppColor.kGoogleGreen
        : AppColor.kGoogleYellow;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.kAuthSurface,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColor.kAuthBorder.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Image area ──
            Container(
              width: 100,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.kBackground.withOpacity(0.3),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
              child: _buildListingImage(listing.imageUrl),
            ),

            // ── Content area ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                listing.partName,
                                variant: AppTextVariant.title,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColor.kAuthTextPrimary,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              AppText(
                                listing.brand.isNotEmpty
                                    ? listing.brand
                                    : 'Other',
                                variant: AppTextVariant.caption,
                                color: AppColor.kGoogleBlue,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AppText(
                              _formatPrice(listing.price),
                              variant: AppTextVariant.title,
                              color: AppColor.kGoogleBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: AppText(
                        listing.compatibleModel.isNotEmpty
                            ? listing.compatibleModel
                            : 'No specific compatibility provided',
                        variant: AppTextVariant.caption,
                        color: AppColor.kAuthTextSecondary,
                        fontSize: 11,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              AppText(
                                status,
                                variant: AppTextVariant.body,
                                color: statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),

                        // Actions Menu
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _handleEditListing(listing);
                            } else if (value == 'delete') {
                              _handleDeleteListing(listing);
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                    color: AppColor.kGoogleBlue,
                                  ),
                                  const SizedBox(width: 12),
                                  const Text('Edit Details'),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline_rounded,
                                    size: 18,
                                    color: AppColor.kGoogleRed,
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Remove Post',
                                    style: TextStyle(
                                      color: AppColor.kGoogleRed,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColor.kBackground,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.more_horiz_rounded,
                              size: 18,
                              color: AppColor.kAuthTextSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingImage(String imageUrl) {
    final trimmed = imageUrl.trim();

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
          ],
        ),
        child: trimmed.isEmpty
            ? _buildFallbackListingImage()
            : trimmed.startsWith('http')
            ? Image.network(
                trimmed,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => _buildFallbackListingImage(),
              )
            : trimmed.startsWith('/')
            ? Image.file(
                File(trimmed),
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => _buildFallbackListingImage(),
              )
            : Image.asset(
                trimmed,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => _buildFallbackListingImage(),
              ),
      ),
    );
  }

  Widget _buildFallbackListingImage() {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Image.asset(
        'assets/images/laptop.png',
        color: AppColor.kGoogleBlue,
      ),
    );
  }

  String _formatPrice(double price) {
    if (price == price.roundToDouble()) {
      return '\$${price.toStringAsFixed(0)}';
    }
    return '\$${price.toStringAsFixed(2)}';
  }

  void _handleEditListing(PostModel listing) {
    // Navigate to edit listing page with the listing data
    controller.selectedCategoryIdForPost.value = '';
    Get.to(() => PostHardwareView(editingPost: listing));
  }

  void _handleDeleteListing(PostModel listing) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColor.kAuthSurface,
        title: AppText(
          'Delete Listing',
          variant: AppTextVariant.title,
          color: AppColor.kGoogleRed,
        ),
        content: AppText(
          'Are you sure you want to delete "${listing.partName}"? This action cannot be undone.',
          variant: AppTextVariant.body,
          color: AppColor.kAuthTextPrimary,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: AppText(
              'Cancel',
              variant: AppTextVariant.body,
              color: AppColor.kGoogleBlue,
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteListing(listing.id);
            },
            child: const AppText(
              'Delete',
              variant: AppTextVariant.body,
              color: Colors.red,
            ),
          ),
        ],
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
              color: AppColor.kAuthTextSecondary.withOpacity(0.4),
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
              borderSide: BorderSide(color: Colors.black.withOpacity(0.03)),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
