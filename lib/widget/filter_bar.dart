import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_assgn/features/search/controllers/search_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({
    super.key,
    this.fitsYourDeviceOnly = true,
    this.onFitsYourDeviceChanged,
    this.sortOption = SearchSortOption.newest,
    this.onSortOptionChanged,
    this.conditionFilter = SearchConditionFilter.any,
    this.onConditionFilterChanged,
    this.onClearFilters,
    this.showClearFilters = false,
  });

  final bool fitsYourDeviceOnly;
  final ValueChanged<bool>? onFitsYourDeviceChanged;
  final SearchSortOption sortOption;
  final ValueChanged<SearchSortOption>? onSortOptionChanged;
  final SearchConditionFilter conditionFilter;
  final ValueChanged<SearchConditionFilter>? onConditionFilterChanged;
  final VoidCallback? onClearFilters;
  final bool showClearFilters;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Apply Any Filter',
            variant: AppTextVariant.body,
            fontSize: 14,
            color: AppColor.kTextSecondary,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildSortChip(context),
                      const SizedBox(width: 8),
                      _buildPriceChip(context),
                      const SizedBox(width: 8),
                      _buildConditionChip(context),
                      if (showClearFilters) ...[
                        const SizedBox(width: 8),
                        _buildClearChip(),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Laptop Icon
              SvgPicture.asset(
                'assets/icons/laptop-minimal.svg',
                colorFilter: ColorFilter.mode(
                  AppColor.kGoogleBlue,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),

              // Custom Switch
              GestureDetector(
                onTap: () =>
                    onFitsYourDeviceChanged?.call(!fitsYourDeviceOnly),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 46,
                  height: 28,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: fitsYourDeviceOnly
                        ? Colors.blue.shade600
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 160),
                    curve: Curves.easeOut,
                    alignment: fitsYourDeviceOnly
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(BuildContext context) {
    return _FilterMenuChip<SearchSortOption>(
      label: sortOption == SearchSortOption.newest ||
              sortOption == SearchSortOption.oldest
          ? sortOption.label
          : 'Newest',
      value: sortOption,
      values: const [
        SearchSortOption.newest,
        SearchSortOption.oldest,
      ],
      onSelected: onSortOptionChanged,
    );
  }

  Widget _buildPriceChip(BuildContext context) {
    final selected = sortOption == SearchSortOption.priceLowToHigh ||
        sortOption == SearchSortOption.priceHighToLow;
    return _FilterMenuChip<SearchSortOption>(
      label: selected ? sortOption.label : 'Price',
      value: sortOption,
      values: const [
        SearchSortOption.priceLowToHigh,
        SearchSortOption.priceHighToLow,
      ],
      onSelected: onSortOptionChanged,
    );
  }

  Widget _buildConditionChip(BuildContext context) {
    return _FilterMenuChip<SearchConditionFilter>(
      label: conditionFilter == SearchConditionFilter.any
          ? 'Condition'
          : conditionFilter.label,
      value: conditionFilter,
      values: SearchConditionFilter.values,
      onSelected: onConditionFilterChanged,
    );
  }

  Widget _buildClearChip() {
    return GestureDetector(
      onTap: onClearFilters,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColor.kGoogleRed.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColor.kGoogleRed.withValues(alpha: 0.2)),
        ),
        child: const AppText(
          'Clear',
          fontSize: 11.5,
          color: AppColor.kGoogleRed,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _FilterMenuChip<T> extends StatelessWidget {
  const _FilterMenuChip({
    required this.label,
    required this.value,
    required this.values,
    this.onSelected,
  });

  final String label;
  final T value;
  final List<T> values;
  final ValueChanged<T>? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      initialValue: values.contains(value) ? value : null,
      onSelected: onSelected,
      color: AppColor.kSurface,
      position: PopupMenuPosition.under,
      itemBuilder: (_) => values
          .map(
            (item) => PopupMenuItem<T>(
              value: item,
              child: AppText(
                _labelFor(item),
                color: AppColor.kTextPrimary,
                fontSize: 12,
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        decoration: BoxDecoration(
          color: AppColor.kSurface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColor.kBorder),
        ),
        child: Row(
          children: [
            AppText(
              label,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AppColor.kTextSecondary,
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: AppColor.kTextSecondary,
            ),
          ],
        ),
      ),
    );
  }

  String _labelFor(T value) {
    if (value is SearchSortOption) return value.label;
    if (value is SearchConditionFilter) return value.label;
    return value.toString();
  }
}
