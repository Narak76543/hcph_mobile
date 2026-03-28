import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';
import 'package:school_assgn/widget/swipe_logout_button.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: Image.asset(
                  'assets/images/norton_university.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
              // ── Top bar ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
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
                    Icon(
                      Icons.search_rounded,
                      color: AppColor.kAuthAccent,
                      size: 24,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Profile header card ──
                      _buildHeaderCard(),
                      const SizedBox(height: 24),

                      // ── Account Setting ──
                      _buildSectionLabel('Account Setting'),
                      const SizedBox(height: 8),
                      _buildSection([
                        _buildRowItem(
                          icon: Icons.person_outline_rounded,
                          label: 'Profile',
                          onTap: () => Get.toNamed('/edit-profile'),
                        ),
                        _buildDivider(),
                        _buildRowItem(
                          icon: Icons.lock_outline_rounded,
                          label: 'Password & Security',
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildRowItem(
                          icon: Icons.devices_rounded,
                          label: 'Device Identification',
                          onTap: () {},
                        ),
                      ]),
                      const SizedBox(height: 24),

                      // ── Set Your Laptop Model ──
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
                              final nickname = laptop['nickname'] as String?;
                              final id = laptop['id'] as String? ?? '';

                              final specs = [
                                if (model?['cpu'] != null) model!['cpu'],
                                if (model?['release_year'] != null)
                                  model!['release_year'].toString(),
                              ].join(' • ');

                              return Dismissible(
                                key: Key(id),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) => controller.removeLaptop(id),
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    color: AppColor.kGoogleRed.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: AppColor.kGoogleRed,
                                    size: 22,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: AppColor.kGoogleBlue
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.laptop_mac_rounded,
                                          color: AppColor.kGoogleBlue,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              nickname ??
                                                  modelName ??
                                                  'Unknown Laptop',
                                              variant: AppTextVariant.title,
                                              color: AppColor.kAuthTextPrimary,
                                              fontSize: 14,
                                            ),
                                            if (specs.isNotEmpty) ...[
                                              const SizedBox(height: 3),
                                              AppText(
                                                specs,
                                                variant: AppTextVariant.caption,
                                                color:
                                                    AppColor.kAuthTextSecondary,
                                                fontSize: 11,
                                              ),
                                            ] else ...[
                                              const SizedBox(height: 3),
                                              AppText(
                                                'ID: ${id.length > 8 ? id.substring(0, 8) : id}',
                                                variant: AppTextVariant.caption,
                                                color:
                                                    AppColor.kAuthTextSecondary,
                                                fontSize: 11,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: AppColor.kAuthTextSecondary,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            _buildDivider(),
                          ],
                          // Add button
                          _buildRowItem(
                            icon: Icons.add_circle_outline_rounded,
                            label: laptops.isEmpty
                                ? 'Set Your Laptop Model'
                                : 'Add Another Laptop',
                            iconColor: AppColor.kGoogleBlue,
                            onTap: () => controller.showSetLaptopSheet(context),
                          ),
                        ]);
                      }),
                      const SizedBox(height: 24),

                      // ── Shop / Role section ──
                      Obx(() {
                        if (controller.isTechnicalRole.value) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionLabel('Shop Management'),
                              const SizedBox(height: 8),
                              _buildSection([
                                _buildRowItem(
                                  icon: Icons.inventory_2_outlined,
                                  label: 'My Listings',
                                  onTap: () {},
                                ),
                                _buildDivider(),
                                Obx(
                                  () => _buildRowItem(
                                    icon: Icons.insights_rounded,
                                    label: 'Shop Analytics',
                                    trailing: AppText(
                                      '${controller.shopViews.value} views',
                                      variant: AppTextVariant.caption,
                                      color: AppColor.kGoogleGreen,
                                      fontSize: 12,
                                    ),
                                    onTap: () {},
                                    showChevron: false,
                                  ),
                                ),
                              ]),
                              const SizedBox(height: 24),
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
                                      icon: Icons.hourglass_top_rounded,
                                      label: 'Request Pending Review',
                                      iconColor: AppColor.kGoogleYellow,
                                      trailing: const Icon(
                                        Icons.hourglass_top_rounded,
                                        size: 16,
                                        color: AppColor.kGoogleYellow,
                                      ),
                                      onTap: () {},
                                      showChevron: false,
                                    ),
                                  ]);
                                }
                                return _buildSection([
                                  _buildRowItem(
                                    icon: Icons.storefront_outlined,
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

                      // ── Preferences ──
                      _buildSectionLabel('Preferences'),
                      const SizedBox(height: 8),
                      _buildSection([
                        Obx(
                          () => _buildToggleItem(
                            icon: Icons.dark_mode_outlined,
                            label: 'Dark Mode',
                            value: controller.isDarkMode.value,
                            onChanged: controller.toggleTheme,
                          ),
                        ),
                        _buildDivider(),
                        Obx(
                          () => _buildLanguageItem(
                            value: controller.isKhmerLanguage.value,
                            onChanged: controller.toggleLanguage,
                          ),
                        ),
                        _buildDivider(),
                        _buildRowItem(
                          icon: Icons.notifications_outlined,
                          label: 'Notifications',
                          onTap: () {},
                        ),
                      ]),
                      const SizedBox(height: 24),

                      // ── Privacy & Terms ──
                      _buildSectionLabel('Privacy & Terms'),
                      const SizedBox(height: 8),
                      _buildSection([
                        _buildRowItem(
                          icon: Icons.privacy_tip_outlined,
                          label: 'Privacy Policy',
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildRowItem(
                          icon: Icons.description_outlined,
                          label: 'Term of Use',
                          onTap: () {},
                        ),
                      ]),
                      const SizedBox(height: 20),

                      // ── Logout ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SwipeLogoutButton(onLogout: controller.logout),
                      ),
                      const SizedBox(height: 120), // Extra space for navbar
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);
}

  // ─────────────────────── Header Card ───────────────────────

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.kAuthSurface,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: const AssetImage('assets/images/norton_university.png'),
          fit: BoxFit.cover,
          opacity: 0.15,
          colorFilter: ColorFilter.mode(
            AppColor.kAuthSurface.withOpacity(0.8),
            BlendMode.dstATop,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.kShadow,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Obx(
            () => Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.kAuthAccent.withOpacity(0.3),
                  width: 2,
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
                  ),
                  const SizedBox(height: 3),
                  AppText(
                    controller.userBadge.value,
                    variant: AppTextVariant.caption,
                    color: AppColor.kAuthTextSecondary,
                    fontSize: 13,
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
        color: AppColor.kAuthSurface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColor.kShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColor.kShadow,
      indent: 52,
    );
  }

  Widget _buildRowItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    Color? labelColor,
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
            Icon(icon, color: iconColor ?? AppColor.kAuthAccent, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: AppText(
                label,
                variant: AppTextVariant.body,
                color: labelColor ?? AppColor.kAuthTextPrimary,
                fontSize: 14,
              ),
            ),
            if (trailing != null) trailing,
            if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                color: AppColor.kAuthTextSecondary.withOpacity(0.5),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColor.kAuthAccent, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: AppText(
              label,
              variant: AppTextVariant.body,
              color: AppColor.kAuthTextPrimary,
              fontSize: 14,
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColor.kAuthAccent,
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
          Icon(Icons.translate_rounded, color: AppColor.kAuthAccent, size: 22),
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
}
