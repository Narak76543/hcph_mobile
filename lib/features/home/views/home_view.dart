import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:school_assgn/features/home/controllers/home_controller.dart';
import 'package:school_assgn/features/home/views/widgets/home_category_tabs.dart';
import 'package:school_assgn/features/home/views/widgets/home_header.dart';
import 'package:school_assgn/features/home/views/widgets/home_promo_banner.dart';
import 'package:school_assgn/features/home/views/widgets/home_search_bar.dart';
import 'package:school_assgn/features/home/views/widgets/product_card.dart';
import 'package:school_assgn/features/home/views/widgets/shop_card.dart';
import 'package:school_assgn/features/home/views/widgets/upgrade_guide_card.dart';
import 'package:school_assgn/features/profile/controllers/profile_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Header
              const SliverToBoxAdapter(child: HomeHeader()),

              // Search bar
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: HomeSearchBar(),
                ),
              ),

              // Category tabs
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: HomeCategoryTabs(),
                ),
              ),

              // Promo banner
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: HomePromoBanner(),
                ),
              ),

              SliverToBoxAdapter(
                child: Obx(() {
                  final pc = Get.isRegistered<ProfileController>()
                      ? Get.find<ProfileController>()
                      : null;

                  final hasLaptop = pc != null && pc.myLaptops.isNotEmpty;

                  // get first laptop model name
                  final laptopName = hasLaptop
                      ? (pc.myLaptops.first['laptop_model']?['name']
                                ?.toString() ??
                            'Your Laptop')
                      : null;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Title
                        Row(
                          children: [
                            Icon(
                              Icons.laptop_rounded,
                              size: 18,
                              color: AppColor.kAuthAccent,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: AppText(
                                hasLaptop
                                    ? 'For your $laptopName'
                                    : 'For your Laptop',
                                variant: AppTextVariant.title,
                                color: AppColor.kTextPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // ====================Subtitle — changes based on laptop selected ==========================================
                        if (hasLaptop)
                          AppText(
                            'Compatible components found for your device',
                            variant: AppTextVariant.body,
                            color: AppColor.kAuthAccent,
                            fontSize: 12,
                          )
                        else
                          GestureDetector(
                            onTap: () {
                              // TODO: navigate to add laptop screen
                              // Get.to(() => AddLaptopView());
                            },
                            child: Row(
                              children: [
                                AppText(
                                  'Set your laptop model to see compatible parts  ',
                                  variant: AppTextVariant.body,
                                  color: AppColor.kTextSecondary,
                                  fontSize: 12,
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 11,
                                  color: AppColor.kAccent,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),

              // ======================================Compatible Products Grid ================================
              SliverToBoxAdapter(
                child: Obx(() {
                  final pc = Get.isRegistered<ProfileController>()
                      ? Get.find<ProfileController>()
                      : null;
                  final hasLaptop = pc != null && pc.myLaptops.isNotEmpty;

                  // ==================================No laptop selected ================================================
                  if (!hasLaptop) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      padding: const EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.kSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColor.kBorder),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.laptop_outlined,
                            size: 40,
                            color: AppColor.kAuthAccent,
                          ),
                          const SizedBox(height: 12),
                          AppText(
                            'No laptop selected yet',
                            variant: AppTextVariant.title,
                            color: AppColor.kTextPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 6),
                          AppText(
                            'Add your laptop model in Settings to see\nparts that fit your device ✨ ',
                            variant: AppTextVariant.body,
                            color: AppColor.kTextSecondary,
                            fontSize: 12,
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              // TODO: navigate to add laptop screen
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.kAccent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const AppText(
                                'Set Your Laptop',
                                variant: AppTextVariant.body,
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // =======================================Has laptop but no compatible posts==========================================
                  if (controller.displayPosts.isEmpty) {
                    return Column(
                      children: [
                        Center(
                          child: Lottie.asset(
                            'assets/animations/Not-Found.json',
                            height: 154,
                            width: 154,
                            fit: BoxFit.contain,
                            repeat: true,
                            errorBuilder: (_, _, _) => Icon(
                              Icons.check_circle_rounded,
                              color: AppColor.kSuccess,
                              size: 84,
                            ),
                          ),
                        ),
                         AppText('Opp !! Nothing Found Now !', fontSize: 12, color: AppColor.kGoogleRed,),
                      ],
                    );
                  }

                  // =================================Show compatible products grid ==================================================
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.displayPosts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.65,
                          ),
                      itemBuilder: (ctx, i) =>
                          ProductCard(post: controller.displayPosts[i]),
                    ),
                  );
                }),
              ),

              // ==================================
              // Recently Added Section
              // ==================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: _SectionHeader(
                    title: 'Recently Added',
                    actionLabel: 'See All',
                    onActionTap: () {
                      // TODO: navigate to full list
                    },
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Obx(() {
                  // ======= Loading state ===================
                  if (controller.isLoadingRecent.value) {
                    return SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  // ── Empty state
                  if (controller.recentlyAdded.isEmpty) {
                    return SizedBox(
                      height: 100,
                      child: Center(
                        child: AppText(
                          'No products available',
                          variant: AppTextVariant.body,
                          color: AppColor.kTextSecondary,
                        ),
                      ),
                    );
                  }

                  // ── Horizontal scroll (not grid)
                  return SizedBox(
                    height: 258,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.recentlyAdded.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (_, i) => SizedBox(
                        width: 165,
                        child: ProductCard(post: controller.recentlyAdded[i]),
                      ),
                    ),
                  );
                }),
              ),

              // ================================
              // End Recently Added Section
              // ================================

              // ============================================
              // Start : verify Shop Section
              // =============================================
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 26, 16, 12),
                  child: _SectionHeader(title: 'Verified Shops'),
                ),
              ),

              // Shop Card Here ======
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 206,
                  child: Obx(() {
                    if (controller.verifiedShops.isEmpty) {
                      return Center(
                        child: AppText(
                          'No verified shops yet',
                          variant: AppTextVariant.body,
                          color: AppColor.kTextSecondary,
                        ),
                      );
                    }
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.verifiedShops.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        final shop = controller.verifiedShops[i];
                        return ShopCard(
                          shopName: shop['name']?.toString() ?? 'Unknown Shop',
                          location: shop['address']?.toString() ?? '',
                          listingCount:
                              int.tryParse(
                                shop['listing_count']?.toString() ?? '0',
                              ) ??
                              0,
                          logoUrl: shop['shop_pro_img_url']?.toString(),
                          isVerified: true,
                          onTap: () {
                            // TODO: navigate to shop detail
                            // Get.to(() => ShopDetailView(shopId: shop['id']));
                          },
                        );
                      },
                    );
                  }),
                ),
              ),

              // End Shop Card =======

              // =============================================
              // End : verify shop Section
              // =============================================
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(8, 26, 8, 124),
                sliver: SliverToBoxAdapter(child: UpgradeGuideCard()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppText(
            title,
            variant: AppTextVariant.title,
            color: AppColor.kTextPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (actionLabel != null) ...[
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onActionTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              child: AppText(
                actionLabel!,
                variant: AppTextVariant.label,
                color: AppColor.kGoogleBlue,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
