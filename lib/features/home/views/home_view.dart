import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/home/controllers/home_controller.dart';
import 'package:school_assgn/features/home/views/widgets/home_category_tabs.dart';
import 'package:school_assgn/features/home/views/widgets/home_header.dart';
import 'package:school_assgn/features/home/views/widgets/home_promo_banner.dart';
import 'package:school_assgn/features/home/views/widgets/home_search_bar.dart';
import 'package:school_assgn/features/home/views/widgets/product_card.dart';
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

              // "Featured Products" heading
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: AppText(
                    'Featured Products',
                    variant: AppTextVariant.title,
                    color: AppColor.kTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Product grid
              Obx(
                () => controller.displayPosts.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: AppText(
                              'No products available',
                              variant: AppTextVariant.body,
                              color: AppColor.kTextSecondary,
                            ),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (ctx, i) =>
                                ProductCard(post: controller.displayPosts[i]),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
