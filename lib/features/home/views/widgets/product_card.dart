import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/home/controllers/home_controller.dart';
import 'package:school_assgn/features/home/models/home_models.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

/// Grid card displaying a product listing with price, fit badge, and metadata.
class ProductCard extends GetView<HomeController> {
  final PostModel post;
  const ProductCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
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
          Expanded(flex: 3, child: _CardImageSection(post: post)),
          Expanded(flex: 2, child: _CardInfoSection(post: post)),
        ],
      ),
    );
  }
}

// Image section (with overlaid badges)

class _CardImageSection extends GetView<HomeController> {
  final PostModel post;
  const _CardImageSection({required this.post});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _ProductImage(imageUrl: post.imageUrl),
        Positioned(left: 10, bottom: 10, child: _PriceBadge(price: post.price)),
        Positioned(left: 10, top: 10, child: _FitBadge(post: post)),
        const Positioned(right: 10, top: 10, child: _WishlistButton()),
      ],
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String imageUrl;
  const _ProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        child: imageUrl.startsWith('http')
            ? Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.contain,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColor.kAuthAccent.withValues(alpha: 0.5),
                        ),
                      ),
                errorBuilder: (_, _, _) => const _ImagePlaceholder(),
              )
            : Image.asset(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const _ImagePlaceholder(),
              ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.memory_rounded,
        color: AppColor.kAuthBorder.withValues(alpha: 0.5),
        size: 40,
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final double price;
  const _PriceBadge({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: AppColor.kAccent,
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
        '\$${price.toStringAsFixed(2)}',
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Shows "Fit with your device" badge only when compatible.
class _FitBadge extends GetView<HomeController> {
  final PostModel post;
  const _FitBadge({required this.post});

  @override
  Widget build(BuildContext context) {
    if (!controller.isCompatibleWithDevice(post))
      return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColor.kGoogleGreen.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AppColor.kGoogleGreen.withValues(alpha: 0.4),
            blurRadius: 4,
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 10),
          SizedBox(width: 4),
          AppText('Fit with your device', color: Colors.white, fontSize: 8),
        ],
      ),
    );
  }
}

class _WishlistButton extends StatelessWidget {
  const _WishlistButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5),
        ],
      ),
      child: const Icon(
        Icons.favorite_border_rounded,
        color: Color(0xFFE57373),
        size: 16,
      ),
    );
  }
}

// ── Info section (brand, name, shop, seller) ──────────────────────────────────

class _CardInfoSection extends StatelessWidget {
  final PostModel post;
  const _CardInfoSection({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BrandRow(brand: post.brand, isVerified: post.isVerified),
          const SizedBox(height: 5),
          _PartNameText(name: post.partName),
          const SizedBox(height: 4),
          _ShopRow(shopName: post.shopName),
          const Spacer(),
          _OwnerRow(ownerName: post.ownerFullName),
        ],
      ),
    );
  }
}

class _BrandRow extends StatelessWidget {
  final String brand;
  final bool isVerified;
  const _BrandRow({required this.brand, required this.isVerified});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isVerified) ...[
          Icon(Icons.verified_rounded, size: 14, color: AppColor.kGoogleBlue),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Text(
            brand.isNotEmpty ? brand : 'Premium Part',
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
    );
  }
}

class _PartNameText extends StatelessWidget {
  final String name;
  const _PartNameText({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: AppColor.kAuthTextPrimary,
        height: 1.2,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ShopRow extends StatelessWidget {
  final String shopName;
  const _ShopRow({required this.shopName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.storefront_rounded,
          size: 12,
          color: AppColor.kAccent.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            shopName,
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
    );
  }
}

class _OwnerRow extends StatelessWidget {
  final String ownerName;
  const _OwnerRow({required this.ownerName});

  @override
  Widget build(BuildContext context) {
    return Row(
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
            ownerName,
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
    );
  }
}
