import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/home/controllers/home_controller.dart';
import 'package:school_assgn/features/home/models/home_models.dart';
import 'package:school_assgn/themes/app_color.dart';

class HomeSearchBar extends GetView<HomeController> {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasText = controller.searchQuery.value.isNotEmpty;
      final suggestions = controller.displayPosts.take(6).toList();

      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _SearchInput(hasText: hasText)),
              if (!hasText) const SizedBox(width: 10),
              if (!hasText) const _FilterButton(),
            ],
          ),
          if (hasText) _SuggestionDropdown(suggestions: suggestions),
        ],
      );
    });
  }
}

// ── Search Input ──────────────────────────────────────────────────────────────

class _SearchInput extends GetView<HomeController> {
  final bool hasText;
  const _SearchInput({required this.hasText});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            color: AppColor.kAuthTextSecondary.withValues(alpha: 0.5),
            fontFamily: 'Poppins',
            fontSize: 13,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.search_rounded,
              color: AppColor.kAuthTextSecondary.withValues(alpha: 0.7),
              size: 22,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

// ── Filter Button ─────────────────────────────────────────────────────────────

class _FilterButton extends StatelessWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
    );
  }
}

// ── Suggestion Dropdown ───────────────────────────────────────────────────────

class _SuggestionDropdown extends StatelessWidget {
  final List<PostModel> suggestions;
  const _SuggestionDropdown({required this.suggestions});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.kAuthSurface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
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
          const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
          ...suggestions.map((p) => _SuggestionItem(post: p)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _SuggestionItem extends GetView<HomeController> {
  final PostModel post;
  const _SuggestionItem({required this.post});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.searchQuery.value = post.partName;
        controller.searchController.text = post.partName;
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
                post.partName,
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
}
