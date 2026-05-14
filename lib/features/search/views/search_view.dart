import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/home/views/widgets/home_category_tabs.dart'
    show CategoryChip;
import 'package:school_assgn/features/search/controllers/search_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/filter_bar.dart';
import 'package:school_assgn/widget/header.dart';
import 'package:school_assgn/widget/showing_part.dart';
import 'package:school_assgn/widget/text_widget.dart';

class SearchView extends GetView<SearchFeatureController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshSearch,
          color: AppColor.kGoogleBlue,
          backgroundColor: AppColor.kSurface,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // Search Header
              const SliverToBoxAdapter(child: HeaderWidget()),
              // SearchBar
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: _SearchInput(),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: _SearchCategoryTabs(),
                ),
              ),
              SliverToBoxAdapter(
                child: Obx(
                  () => FilterBar(
                    fitsYourDeviceOnly: controller.fitsYourDeviceOnly.value,
                    onFitsYourDeviceChanged:
                        controller.setFitsYourDeviceOnly,
                    sortOption: controller.sortOption.value,
                    onSortOptionChanged: controller.setSortOption,
                    conditionFilter: controller.conditionFilter.value,
                    onConditionFilterChanged:
                        controller.setConditionFilter,
                    showClearFilters: controller.hasActiveFilters,
                    onClearFilters: controller.clearFilters,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Obx(
                  () => Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: ShowingCard(
                      laptopName: controller.fitsYourDeviceOnly.value
                          ? controller.selectedLaptopName
                          : null,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 42),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return _EmptySearchState(
                      icon: Icons.wifi_off_rounded,
                      title: controller.errorMessage.value,
                      subtitle: 'Pull down to try again.',
                    );
                  }

                  final products = controller.displayProducts;
                  if (products.isEmpty) {
                    return const _EmptySearchState(
                      icon: Icons.search_off_rounded,
                      title: 'No matching parts found',
                      subtitle:
                          'Try another keyword or turn off the device filter.',
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 124),
                    itemCount: products.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (_, index) {
                      final post = products[index];
                      return SearchProductCard(
                        post: post,
                        fitsYourDevice: controller.isCompatibleWithDevice(post),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchCategoryTabs extends GetView<SearchFeatureController> {
  const _SearchCategoryTabs();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categories = controller.categories;
      final selectedCategoryId = controller.selectedCategoryId.value;

      return SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length + 1,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, index) {
            if (index == 0) {
              return CategoryChip(
                label: 'All Parts',
                icon: Icons.apps_rounded,
                selected: selectedCategoryId == '0',
                onTap: () => controller.setCategory('0'),
              );
            }

            final category = categories[index - 1];
            return CategoryChip(
              label: category.name,
              icon: category.icon,
              imageUrl: category.imageUrl,
              selected: selectedCategoryId == category.id,
              onTap: () => controller.setCategory(category.id),
            );
          },
        ),
      );
    });
  }
}

class _SearchInput extends GetView<SearchFeatureController> {
  const _SearchInput();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.kSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColor.kBorder,
          width: AppColor.kBorderWidth,
        ),
      ),
      child: TextField(
        controller: controller.searchController,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: AppColor.kTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: TextStyle(
            color: AppColor.kTextSecondary.withValues(alpha: 0.6),
            fontFamily: 'Poppins',
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColor.kTextSecondary.withValues(alpha: 0.7),
          ),
          suffixIcon: Obx(() {
            if (controller.searchQuery.value.isEmpty) {
              return const SizedBox.shrink();
            }
            return IconButton(
              onPressed: controller.searchController.clear,
              icon: Icon(
                Icons.close_rounded,
                color: AppColor.kTextSecondary,
              ),
            );
          }),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 124),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        decoration: BoxDecoration(
          color: AppColor.kSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColor.kBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColor.kTextSecondary, size: 38),
            const SizedBox(height: 12),
            AppText(
              title,
              color: AppColor.kTextPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            AppText(
              subtitle,
              color: AppColor.kTextSecondary,
              fontSize: 12,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
