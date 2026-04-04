import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/home/controllers/home_controller.dart';
import 'package:school_assgn/features/home/models/home_models.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: controller.refreshHome,
            color: AppColor.kGoogleBlue,
            backgroundColor: AppColor.kSurface,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // ── Header ──
                SliverToBoxAdapter(child: _buildHeader()),

                // ── Search bar ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: _buildSearchBar(),
                  ),
                ),

                // ── Category tabs ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _buildCategoryTabs(),
                  ),
                ),

                // ── Promo banner ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _buildPromoBanner(),
                  ),
                ),

                // ── Featured Products header ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: AppText(
                      'Featured Products',
                      variant: AppTextVariant.title,
                      color: AppColor.kTextPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // ── Product grid ──
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _buildProductCard(controller.displayPosts[i]),
                      childCount: controller.displayPosts.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.65,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────── Header ───────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Obx(() {
            String avatarUrl =
                'https://ui-avatars.com/api/?name=U&background=0D8ABC&color=fff&size=128';
            String name = 'User';
            try {
              final pc = Get.find<ProfileController>();
              avatarUrl = pc.userAvatarUrl.value;
              name = pc.userName.value;
            } catch (_) {}

            return Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.kAuthAccent.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(avatarUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Welcome Back',
                      variant: AppTextVariant.caption,
                      color: AppColor.kAuthTextSecondary,
                      fontSize: 12,
                    ),
                    Row(
                      children: [
                        AppText(
                          name,
                          variant: AppTextVariant.title,
                          color: AppColor.kAuthTextPrimary,
                          fontSize: 15,
                        ),
                        const SizedBox(width: 4),
                        const Text('🔥', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColor.kAuthSurface,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: AppColor.kShadow, blurRadius: 8)],
            ),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                AppColor.kAuthTextPrimary,
                BlendMode.srcIn,
              ),
              child: Image.asset(
                'assets/images/notification-bell.png',
                width: 22,
                height: 22,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── Search bar ───────────────────
  Widget _buildSearchBar() {
    return Obx(() {
      final hasText = controller.searchQuery.value.isNotEmpty;
      final suggestions = controller.displayPosts.take(6).toList();

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.kAuthSurface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10),
                      bottomLeft: Radius.circular(hasText ? 0 : 10),
                      bottomRight: Radius.circular(hasText ? 0 : 10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: TextStyle(
                        color: AppColor.kAuthTextSecondary.withValues(
                          alpha: 0.5,
                        ),
                        fontFamily: 'Poppins',
                        fontSize: 14,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.search_rounded,
                          color: AppColor.kAuthTextSecondary.withValues(
                            alpha: 0.7,
                          ),
                          size: 22,
                        ),
                      ),
                      // suffixIcon: Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 12),
                      //   child: Icon(
                      //     Icons.mic_rounded,
                      //     color: AppColor.kAuthTextSecondary.withValues(
                      //       alpha: 0.7,
                      //     ),
                      //     size: 22,
                      //   ),
                      // ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
              if (!hasText) const SizedBox(width: 10),
              if (!hasText)
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: AppColor.kAuthAccent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.kAuthAccent.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
            ],
          ),
          if (hasText)
            Container(
              margin: const EdgeInsets.only(right: 0), // Match expanded bar
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.kAuthSurface,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF5F5F5),
                  ),
                  ...suggestions.map((p) => _buildSuggestionItem(p)),
                  const SizedBox(height: 10),
                ],
              ),
            ),
        ],
      );
    });
  }

  Widget _buildSuggestionItem(PostModel p) {
    return InkWell(
      onTap: () {
        controller.searchQuery.value = p.partName;
        controller.searchController.text = p.partName;
        // Optionally focus/unfocus here
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              size: 16,
              color: AppColor.kAuthTextSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                p.partName,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppColor.kAuthTextSecondary.withValues(alpha: 0.8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────── Category tabs ───────────────────

  Widget _buildCategoryTabs() {
    final cats = controller.categories;
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cats.length + 1, // +1 for "All Parts"
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          return Obx(() {
            final isAll = i == 0;
            final categoryId = isAll ? '0' : cats[i - 1].id;
            final isSelected =
                controller.selectedCategoryId.value == categoryId;

            final label = isAll ? 'All Parts' : cats[i - 1].name;
            final icon = isAll ? Icons.apps_rounded : cats[i - 1].icon;
            final imgUrl = isAll ? null : cats[i - 1].imageUrl;

            return _CategoryChip(
              label: label,
              icon: icon,
              imageUrl: imgUrl,
              selected: isSelected,
              onTap: () => controller.selectedCategoryId.value = categoryId,
            );
          });
        },
      ),
    );
  }

  // ─────────────────── Promo Banner ───────────────────

  Widget _buildPromoBanner() {
    final banners = controller.topUpgrades;
    final pageCtrl = PageController();
    final pageIndex = 0.obs;

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: Obx(
            () => PageView.builder(
              controller: pageCtrl,
              itemCount: banners.length,
              onPageChanged: (i) => pageIndex.value = i,
              itemBuilder: (ctx, i) => _buildBannerCard(banners[i]),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: pageIndex.value == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: pageIndex.value == i
                      ? AppColor.kAuthAccent
                      : AppColor.kAuthBorder,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCard(UpgradeModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 0,
            top: 0,
            child: item.imageUrl.startsWith('http')
                ? Image.network(
                    item.imageUrl,
                    width: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.memory_rounded,
                      color: Colors.white30,
                      size: 80,
                    ),
                  )
                : Image.asset(
                    item.imageUrl,
                    width: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.memory_rounded,
                      color: Colors.white30,
                      size: 80,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 110, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.discount,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    height: 1.3,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontFamily: 'Poppins',
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.kSurface,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: AppColor.kAuthAccent,
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Find Now',
                        style: TextStyle(
                          color: AppColor.kAuthAccent,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────── Product Card ───────────────────

  Widget _buildProductCard(PostModel post) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.kAuthSurface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image area ──
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: post.imageUrl.startsWith('http')
                        ? Image.network(
                            post.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            loadingBuilder: (_, child, progress) =>
                                progress == null
                                ? child
                                : Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColor.kAuthAccent.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                            errorBuilder: (_, _, _) =>
                                _buildProductPlaceHolder(),
                          )
                        : Image.asset(
                            post.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) =>
                                _buildProductPlaceHolder(),
                          ),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.kAuthAccent,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.kAuthAccent.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      '\$${post.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: _buildFitBadge(post),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      color: Color(0xFFE57373),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Info area ──
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (post.isVerified)
                        Icon(
                          Icons.verified_rounded,
                          size: 14,
                          color: AppColor.kGoogleBlue,
                        ),
                      if (post.isVerified) const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          post.brand.isNotEmpty ? post.brand : 'Premium Part',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColor.kGoogleBlue,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    post.partName,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColor.kAuthTextPrimary,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.storefront_rounded,
                        size: 11,
                        color: AppColor.kGoogleRed.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          post.shopName,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            color: AppColor.kAuthTextSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.kBackground,
                        ),
                        child: Icon(
                          Icons.person_outline_rounded,
                          size: 10,
                          color: AppColor.kAuthTextSecondary,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          post.ownerFullName,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 9,
                            color: AppColor.kAccentLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
    );
  }

  Widget _buildFitBadge(PostModel post) {
    if (!_isCompatibleWithUserDevice(post)) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColor.kGoogleGreen,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AppColor.kGoogleGreen.withValues(alpha: 0.3),
            blurRadius: 4,
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 10),
          SizedBox(width: 4),
          AppText(
            "Fit with your device",
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  bool _isCompatibleWithUserDevice(PostModel post) {
    try {
      if (!Get.isRegistered<ProfileController>()) return false;
      final pc = Get.find<ProfileController>();
      if (pc.myLaptops.isEmpty) return false;

      final postBrand = post.brand.toLowerCase().trim();
      final postCompat = post.compatibleModel.toLowerCase();
      final postName = post.partName.toLowerCase();

      for (final userLap in pc.myLaptops) {
        final model = userLap['laptop_model'];
        if (model is Map) {
          // Check Brand Match
          final brandName =
              model['brand']?['name']?.toString().toLowerCase().trim() ?? '';
          if (brandName.isNotEmpty &&
              (postBrand == brandName ||
                  postCompat.contains(brandName) ||
                  postBrand.contains(brandName))) {
            return true;
          }

          // Check Model Name Match
          final modelName =
              model['name']?.toString().toLowerCase().trim() ?? '';
          if (modelName.isNotEmpty &&
              (postCompat.contains(modelName) || postName.contains(modelName))) {
            return true;
          }

          // --- 🔧 Technical Spec Matching (Smart Match) ---
          final spec = model['spec'];
          if (spec is Map) {
            // 1. RAM Type Check (e.g., "DDR5")
            final ramType = spec['ram_type']?.toString().toLowerCase().trim() ?? '';
            if (ramType.isNotEmpty &&
                (postName.contains(ramType) || postCompat.contains(ramType))) {
              return true;
            }

            // 2. SSD Interface Check (e.g., "nvme" or "pcie")
            final ssdIf = spec['ssd_interface']?.toString().toLowerCase().trim() ?? '';
            if (ssdIf.isNotEmpty) {
              // Standardize common terms
              final cleanSsdIf = ssdIf.contains('nvme') ? 'nvme' : ssdIf;
              if (postName.contains(cleanSsdIf) || postCompat.contains(cleanSsdIf)) {
                return true;
              }
            }
          }
        }
      }
    } catch (_) {}
    return false;
  }

  Widget _buildProductPlaceHolder() {
    return Center(
      child: Icon(
        Icons.memory_rounded,
        color: AppColor.kAuthBorder.withValues(alpha: 0.5),
        size: 40,
      ),
    );
  }
}

// ─────────────────── Category Chip ───────────────────

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? imageUrl;
  final bool selected;
  final VoidCallback? onTap;

  const _CategoryChip({
    required this.label,
    this.icon,
    this.imageUrl,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColor.kAuthAccent : AppColor.kAuthSurface,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: selected ? AppColor.kAuthAccent : AppColor.kShadow,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColor.kAuthAccent.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLeading(),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: selected ? Colors.white : AppColor.kAuthTextSecondary,
                fontWeight: selected ? FontWeight.w400 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeading() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        width: 20,
        height: 20,
        fit: BoxFit.contain,
        // Only apply tint if selected (white), or the user expects it.
        // Removing the mandatory blue tint allows colorful category icons to shine.
        color: selected ? Colors.white : null,
        errorBuilder: (_, _, _) => Icon(
          icon ?? Icons.widgets_rounded,
          size: 16,
          color: selected ? Colors.white : AppColor.kAuthTextSecondary,
        ),
      );
    }
    return Icon(
      icon ?? Icons.widgets_rounded,
      size: 16,
      color: selected ? Colors.white : AppColor.kAuthTextSecondary,
    );
  }
}
