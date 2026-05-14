import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/home/controllers/home_controller.dart';
import 'package:school_assgn/themes/app_color.dart';

/// Horizontal scrollable row of category filter chips.
class HomeCategoryTabs extends GetView<HomeController> {
  const HomeCategoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cats = controller.categories;
      final selectedCategoryId = controller.selectedCategoryId.value;
      return SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: cats.length + 1, // +1 for "All Parts"
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (ctx, i) {
            final isAll = i == 0;
            final categoryId = isAll ? '0' : cats[i - 1].id;
            final isSelected = selectedCategoryId == categoryId;

            return CategoryChip(
              label: isAll ? 'All Parts' : cats[i - 1].name,
              icon: isAll ? Icons.apps_rounded : cats[i - 1].icon,
              imageUrl: isAll ? null : cats[i - 1].imageUrl,
              selected: isSelected,
              onTap: () => controller.selectedCategoryId.value = categoryId,
            );
          },
        ),
      );
    });
  }
}

/// A single category filter chip with optional image or icon.
class CategoryChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? imageUrl;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
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
          color: selected ? AppColor.kGoogleBlue : AppColor.kSurface,
          borderRadius: BorderRadius.circular(AppColor.kCardRadius),
          border: Border.all(
            color: AppColor.kBorder,
            width: AppColor.kBorderWidth,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ChipLeading(icon: icon, imageUrl: imageUrl, selected: selected),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                color: selected
                    ? AppColor.kBackground
                    : AppColor.kTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipLeading extends StatelessWidget {
  final IconData? icon;
  final String? imageUrl;
  final bool selected;

  const _ChipLeading({
    required this.icon,
    required this.imageUrl,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColor.kBackground : AppColor.kTextSecondary;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      final isSvg = Uri.tryParse(
            imageUrl!,
          )?.path.toLowerCase().endsWith('.svg') ??
          imageUrl!.toLowerCase().endsWith('.svg');

      if (isSvg) {
        return SvgPicture.network(
          imageUrl!,
          width: 20,
          height: 20,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          placeholderBuilder: (_) => SizedBox(
            width: 20,
            height: 20,
            child: Icon(icon ?? Icons.widgets_rounded, size: 16, color: color),
          ),
        );
      }

      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: 20,
        height: 20,
        fit: BoxFit.contain,
        color: color,
        errorWidget: (_, _, _) => Icon(
          icon ?? Icons.widgets_rounded,
          size: 16,
          color: color,
        ),
      );
    }
    return Icon(
      icon ?? Icons.widgets_rounded,
      size: 16,
      color: color,
    );
  }
}
