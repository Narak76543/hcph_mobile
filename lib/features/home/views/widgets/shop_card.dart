
import 'package:flutter/material.dart';
import 'package:school_assgn/themes/app_color.dart';

class ShopCard extends StatelessWidget {
  final String shopName;
  final String location;
  final int listingCount;
  final String? logoUrl;
  final bool isVerified;
  final VoidCallback? onTap;

  const ShopCard({
    super.key,
    required this.shopName,
    required this.location,
    required this.listingCount,
    this.logoUrl,
    this.isVerified = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 152,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColor.kBorder.withValues(alpha: 0.8),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.kShadow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ====================================Logo =================================
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColor.kBackground,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColor.kBorder.withValues(alpha: 0.8),
                  width: 0.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: logoUrl != null && logoUrl!.isNotEmpty
                    ? Image.network(
                        logoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const _DefaultLogo(),
                      )
                    : const _DefaultLogo(),
              ),
            ),

            const SizedBox(height: 10),

            // ==============================================Shop name ==============================
            Text(
              shopName,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColor.kTextPrimary,
                height: 1.25,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // ==================================Location · listing count ==========================
            Text(
              '$location · ${_formatCount(listingCount)} items',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10.5,
                color: AppColor.kTextSecondary,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 10),

            // =======================================Divider ========================================
            Divider(
              height: 1,
              thickness: 0.5,
              color: AppColor.kBorder.withValues(alpha: 0.65),
            ),

            const SizedBox(height: 10),

            // ==================================Verified badge =========================================
            if (isVerified)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 13,
                    color: AppColor.kSuccess,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Verified',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColor.kSuccess,
                    ),
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 13,
                    color: AppColor.kTextSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Pending',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColor.kTextSecondary,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(count % 1000 == 0 ? 0 : 1)}K';
    }
    return count.toString();
  }
}

// ==========================================Default logo when no image ======================================================
class _DefaultLogo extends StatelessWidget {
  const _DefaultLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.kCard,
      child: Icon(
        Icons.storefront_rounded,
        size: 26,
        color: const Color(0xFF7D9AB8),
      ),
    );
  }
}
