import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/home/controllers/home_controller.dart';
import 'package:school_assgn/features/home/models/home_models.dart';
import 'package:school_assgn/themes/app_color.dart';

/// Auto-scrolling promotional banner with page indicators.
class HomePromoBanner extends GetView<HomeController> {
  const HomePromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
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
              itemBuilder: (ctx, i) => _BannerCard(item: banners[i]),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (i) => _PageDot(active: pageIndex.value == i),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Page dot indicator ────────────────────────────────────────────────────────

class _PageDot extends StatelessWidget {
  final bool active;
  const _PageDot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: active ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? AppColor.kTextPrimary : AppColor.kBorder,
        borderRadius: BorderRadius.circular(AppColor.kCardRadius),
      ),
    );
  }
}

// ── Individual banner card ────────────────────────────────────────────────────

class _BannerCard extends StatelessWidget {
  final UpgradeModel item;
  const _BannerCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF171717), Color(0xFF000000)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(AppColor.kCardRadius)),
        border: Border.all(
          color: AppColor.kBorder,
          width: AppColor.kBorderWidth,
        ),
      ),
      child: Stack(
        children: [
          // Background circle decoration
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
          // Product image
          Positioned(
            right: 12,
            bottom: 0,
            top: 0,
            child: _BannerImage(url: item.imageUrl),
          ),
          // Text content + CTA
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 110, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DiscountBadge(label: item.discount),
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
                const _FindNowButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerImage extends StatelessWidget {
  final String url;
  const _BannerImage({required this.url});

  @override
  Widget build(BuildContext context) {
    const fallback = Icon(
      Icons.memory_rounded,
      color: Colors.white30,
      size: 80,
    );
    if (url.startsWith('http')) {
      return Image.network(
        url,
        width: 100,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => fallback,
      );
    }
    return Image.asset(
      url,
      width: 120,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  final String label;
  const _DiscountBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: 11,
        ),
      ),
    );
  }
}

class _FindNowButton extends StatelessWidget {
  const _FindNowButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColor.kTextPrimary,
        borderRadius: BorderRadius.circular(AppColor.kCardRadius / 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_rounded, color: AppColor.kBackground, size: 13),
          const SizedBox(width: 5),
          Text(
            'Find Now',
            style: TextStyle(
              color: AppColor.kBackground,
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
