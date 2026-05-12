import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/home/controllers/home_controller.dart';
import 'package:school_assgn/features/home/models/home_models.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';
import 'package:flutter/services.dart';

/// ==========================Grid card displaying a product listing with price, fit badge, and metadata.=========================
class ProductCard extends GetView<HomeController> {
  final PostModel post;
  const ProductCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColor.kSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColor.kBorder.withValues(alpha: 0.8),
          width: AppColor.kBorderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.kShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
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

// ===================================Image section (with overlaid badges)================================================

class _CardImageSection extends GetView<HomeController> {
  final PostModel post;
  const _CardImageSection({required this.post});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _ProductImage(imageUrl: post.imageUrl),
        Positioned(left: 12, bottom: 8, child: _PriceBadge(price: post.price)),
        Positioned(left: 12, top: 12, child: _FitBadge(post: post)),
        const Positioned(right: 12, top: 12, child: _WishlistButton()),
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
      decoration: const BoxDecoration(color: Color(0xFFF8FAFD)),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 28),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.kSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColor.kBorder.withValues(alpha: 0.8),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.kShadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '\$${price.toStringAsFixed(2)}',
        style: TextStyle(
          color: const Color(0xFF3478D8),
          fontFamily: 'Poppins',
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// =========================================Shows "Fit with your device" badge only when compatible.===============================================================
class _FitBadge extends GetView<HomeController> {
  final PostModel post;
  const _FitBadge({required this.post});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isCompatibleWithDevice(post)) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColor.kGoogleGreen,
          borderRadius: BorderRadius.circular(12),
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
    });
  }
}

class _WishlistButton extends StatefulWidget {
  const _WishlistButton();

  @override
  State<_WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<_WishlistButton>
    with SingleTickerProviderStateMixin {
  bool _isFavorite = false;

  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    HapticFeedback.lightImpact();

    setState(() {
      _isFavorite = !_isFavorite;
    });

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,

      child: ScaleTransition(
        scale: _scale,

        child: Container(
          padding: const EdgeInsets.all(7),

          decoration: BoxDecoration(
            color: AppColor.kSurface,
            shape: BoxShape.circle,

            boxShadow: [
              BoxShadow(
                color: AppColor.kShadow,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),

          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),

            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },

            child: Icon(
              _isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,

              key: ValueKey(_isFavorite),

              color: _isFavorite ? Colors.redAccent : const Color(0xFF8EA3C4),

              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ====================================Info section (brand, name, shop, seller)=================================================================

class _CardInfoSection extends StatelessWidget {
  final PostModel post;
  const _CardInfoSection({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BrandRow(brand: post.brand, isVerified: post.isVerified),
          const SizedBox(height: 4),
          _PartNameText(name: post.partName),
          const SizedBox(height: 6),
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
          const Icon(
            Icons.verified_rounded,
            size: 14,
            color: Color(0xFF58A6F7),
          ),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Text(
            brand.isNotEmpty ? brand : 'Premium Part',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B8EB9),
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
        fontSize: 13.5,
        fontWeight: FontWeight.w700,
        color: AppColor.kAuthTextPrimary,
        height: 1.28,
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
        SvgPicture.asset(
          'assets/icons/shopping-bag.svg',
          width: 12,
          height: 12,
          colorFilter: ColorFilter.mode(
            const Color(0xFF9AA4B5),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            shopName,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10.5,
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
          child: SvgPicture.asset(
            'assets/icons/user-round.svg',
            width: 12,
            height: 12,
            colorFilter: ColorFilter.mode(
              const Color(0xFF6CB895),
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            ownerName,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 9.5,
              color: const Color(0xFF9AA7BC),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
