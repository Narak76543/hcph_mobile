import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/profile/views/laptop_detail_view.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';
import 'package:school_assgn/features/profile/views/my_listings_view.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';
import 'package:school_assgn/widget/swipe_logout_button.dart';
import 'package:school_assgn/core/theme/theme_service.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const SizedBox.shrink(),
          SafeArea(
            child: Column(
              children: [
                // ── Top bar ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      AppText(
                        'Setting',
                        variant: AppTextVariant.title,
                        color: AppColor.kAuthAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      const Spacer(),
                      SvgPicture.asset(
                        'assets/icons/search.svg',
                        colorFilter: ColorFilter.mode(
                          AppColor.kAuthAccent,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.refreshProfile,
                    color: AppColor.kGoogleBlue,
                    backgroundColor: AppColor.kSurface,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.only(bottom: 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Profile header card
                          _buildHeaderCard(),
                          const SizedBox(height: 24),

                          // ── Account Setting
                          _buildSectionLabel('Account Setting'),
                          const SizedBox(height: 8),
                          _buildSection([
                            _buildRowItem(
                              iconPath: 'assets/icons/user-round.svg',
                              label: 'Profile',
                              onTap: () => Get.toNamed('/edit-profile'),
                            ),
                            _buildDivider(),
                            _buildRowItem(
                              iconPath: 'assets/icons/lock-keyhole.svg',
                              label: 'Password & Security',
                              onTap: controller.showUnderConstruction,
                            ),
                            _buildDivider(),
                            _buildRowItem(
                              iconPath: 'assets/icons/monitor-smartphone.svg',
                              label: 'Device Identification',
                              onTap: controller.showUnderConstruction,
                            ),
                          ]),
                          const SizedBox(height: 24),

                          // ── Set Your Laptop Model
                          _buildSectionLabel('Set Your Laptop Model'),
                          const SizedBox(height: 8),
                          Obx(() {
                            final laptops = controller.myLaptops;
                            return _buildSection([
                              // Saved laptops list
                              if (laptops.isNotEmpty) ...[
                                ...laptops.map((laptop) {
                                  final Map<String, dynamic>? model =
                                      laptop['laptop_model'] != null
                                      ? Map<String, dynamic>.from(
                                          laptop['laptop_model'],
                                        )
                                      : null;
                                  final modelName = model?['name'] as String?;
                                  final nickname =
                                      laptop['nickname'] as String?;
                                  final id = laptop['id'] as String? ?? '';

                                  final specs = [
                                    if (model?['cpu'] != null) model!['cpu'],
                                    if (model?['release_year'] != null)
                                      model!['release_year'].toString(),
                                  ].join(' • ');

                                  return Dismissible(
                                    key: Key(id),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (_) =>
                                        controller.removeLaptop(id),
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 20),
                                      decoration: BoxDecoration(
                                        color: AppColor.kGoogleRed.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: AppColor.kGoogleRed,
                                        size: 22,
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        // Fetch specifications and navigate
                                        await controller.fetchSpecsForModel(
                                          model?['id']?.toString() ?? '',
                                        );
                                        if (controller
                                                .selectedModelSpec
                                                .value !=
                                            null) {
                                          Get.to(
                                            () => LaptopDetailView(
                                              modelName: modelName ?? 'Laptop',
                                              spec: controller
                                                  .selectedModelSpec
                                                  .value!,
                                            ),
                                          );
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/laptop.png",
                                              height: 25,
                                              color: AppColor.kAuthAccent,
                                            ),
                                            const SizedBox(width: 15),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppText(
                                                    nickname ??
                                                        modelName ??
                                                        'Unknown Laptop',
                                                    variant:
                                                        AppTextVariant.body,
                                                    color: AppColor
                                                        .kAuthTextPrimary,
                                                    fontSize: 14,
                                                  ),
                                                  if (specs.isNotEmpty) ...[
                                                    const SizedBox(height: 3),
                                                    AppText(
                                                      specs,
                                                      variant: AppTextVariant
                                                          .caption,
                                                      color: AppColor
                                                          .kAuthTextSecondary,
                                                      fontSize: 11,
                                                    ),
                                                  ] else ...[
                                                    const SizedBox(height: 3),
                                                    AppText(
                                                      'ID: ${id.length > 8 ? id.substring(0, 8) : id}',
                                                      variant: AppTextVariant
                                                          .caption,
                                                      color: AppColor
                                                          .kAuthTextSecondary,
                                                      fontSize: 11,
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              'assets/icons/spline-pointer.svg',
                                              colorFilter: ColorFilter.mode(
                                                AppColor.kTextSecondary,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                _buildDivider(),
                              ],
                              // Add button
                              _buildRowItem(
                                iconPath: 'assets/icons/circle-plus.svg',
                                label: laptops.isEmpty
                                    ? 'Set Your Laptop Model'
                                    : 'Add Another Laptop',
                                iconColor: AppColor.kGoogleBlue,
                                onTap: () =>
                                    controller.showSetLaptopSheet(context),
                              ),
                            ]);
                          }),
                          const SizedBox(height: 15),

                          // ── Shop / Role section
                          Obx(() {
                            if (controller.isTechnicalRole.value) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionLabel('Shop Management'),
                                  const SizedBox(height: 8),
                                  _buildTechnicalStatus(),
                                  const SizedBox(height: 12),
                                  _buildSection([
                                    _buildRowItem(
                                      iconPath: 'assets/icons/brackets.svg',
                                      label: 'My Listings',
                                      onTap: () =>
                                          Get.to(() => const MyListingsView()),
                                    ),
                                    _buildDivider(),
                                    Obx(
                                      () => _buildRowItem(
                                        iconPath:
                                            'assets/icons/chart-spline.svg',
                                        label: 'Shop Analytics',
                                        trailing: AppText(
                                          '${controller.shopViews.value} views',
                                          variant: AppTextVariant.caption,
                                          color: AppColor.kGoogleGreen,
                                          fontSize: 12,
                                        ),
                                        onTap: controller.showUnderConstruction,
                                        showChevron: false,
                                      ),
                                    ),
                                  ]),
                                  const SizedBox(height: 20),
                                ],
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionLabel('Become a Seller'),
                                  const SizedBox(height: 8),
                                  Obx(() {
                                    if (controller.hasRequestedRole.value) {
                                      return _buildSection([
                                        _buildRowItem(
                                          iconPath: 'assets/icons/clock.svg',
                                          label: 'Request Pending Review',
                                          iconColor: AppColor.kGoogleYellow,
                                          trailing: Image.asset(
                                            'assets/images/info.png',
                                            width: 16,
                                            height: 16,
                                            color: AppColor.kGoogleYellow,
                                          ),
                                          onTap: () {},
                                          showChevron: false,
                                        ),
                                      ]);
                                    }
                                    return _buildSection([
                                      _buildRowItem(
                                        iconPath:
                                            'assets/icons/shield-check.svg',
                                        label: 'Request Technical Role',
                                        onTap: () => controller
                                            .showRequestRoleSheet(context),
                                      ),
                                    ]);
                                  }),
                                  const SizedBox(height: 24),
                                ],
                              );
                            }
                          }),

                          // ── Preferences
                          _buildSectionLabel('Preferences'),
                          const SizedBox(height: 8),
                          _buildSection([
                            Obx(() {
                              final themeService = Get.find<ThemeService>();
                              return _buildToggleItem(
                                leading: SvgPicture.asset(
                                  'assets/icons/moon-star.svg',
                                  colorFilter: ColorFilter.mode(
                                    AppColor.kAuthAccent,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                label: 'Dark Mode',
                                value: themeService.isDarkMode.value,
                                onChanged: (val) => themeService.toggleTheme(),
                              );
                            }),
                            _buildDivider(),
                            Obx(
                              () => _buildLanguageItem(
                                value: controller.isKhmerLanguage.value,
                                onChanged: controller.toggleLanguage,
                              ),
                            ),
                            _buildDivider(),
                            _buildRowItem(
                              iconPath: 'assets/icons/bell.svg',
                              label: 'Notifications',
                              onTap: controller.showUnderConstruction,
                            ),
                          ]),
                          const SizedBox(height: 24),

                          // ── Privacy & Terms
                          _buildSectionLabel('Privacy & Terms'),
                          const SizedBox(height: 8),
                          _buildSection([
                            _buildRowItem(
                              iconPath: 'assets/icons/shield-ellipsis.svg',
                              label: 'Privacy Policy',
                              onTap: controller.showUnderConstruction,
                            ),
                            _buildDivider(),
                            _buildRowItem(
                              iconPath: 'assets/icons/info.svg',
                              label: 'Term of Use',
                              onTap: controller.showUnderConstruction,
                            ),
                          ]),
                          const SizedBox(height: 20),

                          // ── Logout
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SwipeLogoutButton(
                              onLogout: controller.logout,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/copyright.svg',
                                    width: 12,
                                    height: 12,
                                    colorFilter: ColorFilter.mode(
                                      AppColor.kTextSecondary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  AppText(
                                    'Power By : ',
                                    variant: AppTextVariant.body,
                                    fontSize: 11,
                                    color: AppColor.kTextSecondary,
                                  ),

                                  AppText(
                                    'Sarat Narak',
                                    variant: AppTextVariant.body,
                                    fontSize: 11,
                                    color: AppColor.kGoogleBlue,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    'Start Date : ',
                                    variant: AppTextVariant.body,
                                    fontSize: 11,
                                    color: AppColor.kTextSecondary,
                                  ),

                                  AppText(
                                    '25-Mar-2026',
                                    variant: AppTextVariant.body,
                                    fontSize: 11,
                                    color: AppColor.kGoogleBlue,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 120), // Extra space for navbar
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────── Header Card ───────────────────────

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.kSurface,
        borderRadius: BorderRadius.circular(AppColor.kCardRadius),
        border: Border.all(
          color: AppColor.kBorder,
          width: AppColor.kBorderWidth,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Obx(
            () => Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.kAuthAccent.withValues(alpha: 0.35),
                  width: 2.5,
                ),
                image: DecorationImage(
                  image: controller.userAvatarUrl.value.startsWith('assets/')
                      ? AssetImage(controller.userAvatarUrl.value)
                            as ImageProvider
                      : NetworkImage(controller.userAvatarUrl.value),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Name + role + username
          Expanded(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    controller.userName.value,
                    variant: AppTextVariant.title,
                    color: AppColor.kAuthTextPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Image.asset(
                        controller.userRoleIcon.value,
                        width: 17,
                        height: 17,
                        color: controller.userRoleColor.value,
                      ),
                      const SizedBox(width: 4),
                      AppText(
                        controller.userBadge.value,
                        variant: AppTextVariant.caption,
                        color: AppColor.kAuthTextSecondary,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────── Section Helpers ───────────────────────
  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AppText(
        label,
        variant: AppTextVariant.title,
        color: AppColor.kTextSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.kSurface,
        borderRadius: BorderRadius.circular(AppColor.kCardRadius),
        border: Border.all(
          color: AppColor.kBorder,
          width: AppColor.kBorderWidth,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColor.kBorder,
      indent: 52,
    );
  }

  Widget _buildRowItem({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    // Color? labelColor,
    Widget? trailing,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Image.asset(
            //   iconPath,
            //   color: iconColor ?? AppColor.kAuthAccent,
            //   width: 25,
            //   height: 25,
            // ),
            SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(
                iconColor ?? AppColor.kAuthAccent,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 17),
            Expanded(
              child: AppText(
                label,
                variant: AppTextVariant.body,
                color: AppColor.kAuthAccent,
                fontSize: 14,
              ),
            ),
            ?trailing,
            if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                color: AppColor.kAuthTextSecondary.withValues(alpha: 0.5),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    Color? iconColor,
    String? iconPath,
    Widget? leading,
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          leading ??
              SvgPicture.asset(
                iconPath!,
                colorFilter: ColorFilter.mode(
                  iconColor ?? AppColor.kAccent,
                  BlendMode.srcIn,
                ),
              ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  label,
                  variant: AppTextVariant.body,
                  color: AppColor.kAuthTextPrimary,
                  fontSize: 14,
                ),
                AppText(
                  'Light mode is best experince now , because of dark mode is not optimize yet',
                  fontSize: 8,
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColor.kGoogleBlue,
            inactiveTrackColor: AppColor.kBorder,
            thumbColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem({
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Image.asset(
          //   'assets/images/translate.png', // Placeholder, using an asset for consistency
          //   color: AppColor.kAuthAccent,
          //   width: 24,
          //   height: 24,
          // ),
          SvgPicture.asset(
            'assets/icons/globe.svg',
            colorFilter: ColorFilter.mode(
              AppColor.kAuthAccent,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: AppText(
              'Language',
              variant: AppTextVariant.body,
              color: AppColor.kAuthTextPrimary,
              fontSize: 14,
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  value ? 'KH' : 'EN',
                  variant: AppTextVariant.label,
                  color: AppColor.kAuthAccent,
                  fontSize: 14,
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColor.kAuthAccent,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────── Status Banner ───────────────────────

  Widget _buildTechnicalStatus() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.kSurface,
        borderRadius: BorderRadius.circular(AppColor.kCardRadius),
        border: Border.all(
          color: AppColor.kGoogleGreen.withValues(alpha: 0.3),
          width: AppColor.kBorderWidth,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColor.kGoogleGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 0.7,
                color: AppColor.kGoogleGreen.withValues(alpha: 0.7),
              ),
            ),
            child: SvgPicture.asset(
              'assets/icons/wrench.svg',
              colorFilter: ColorFilter.mode(
                AppColor.kGoogleGreen,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppText(
                      'Technical Expert Status',
                      variant: AppTextVariant.body,
                      color: AppColor.kGoogleGreen,
                      fontSize: 13,
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified_rounded,
                      color: AppColor.kGoogleBlue,
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                AppText(
                  'Your technical role is verified. You can now manage listings and shop insights.',
                  variant: AppTextVariant.caption,
                  color: AppColor.kAuthTextSecondary,
                  fontSize: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
