import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_assgn/features/alerts/controllers/alerts_controller.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class AlertsView extends GetView<AlertsController> {
  const AlertsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackground,
      body: SafeArea(
        child: Obx(
          () => RefreshIndicator(
            onRefresh: controller.refreshAlerts,
            color: AppColor.kGoogleBlue,
            backgroundColor: AppColor.kSurface,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(child: _Header(controller: controller)),
                if (controller.isLoading.value &&
                    controller.priceDrops.isEmpty &&
                    controller.savedParts.isEmpty)
                  const SliverToBoxAdapter(child: _LoadingState())
                else ...[
                  SliverToBoxAdapter(
                    child: _SummaryCard(controller: controller),
                  ),
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Price Watch',
                      action: controller.usedFallback ? 'Sample' : 'Live',
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _PriceWatchList(products: controller.priceDrops),
                  ),
                  const SliverToBoxAdapter(
                    child: _SectionHeader(title: 'Saved Parts'),
                  ),
                  SliverToBoxAdapter(
                    child: _SavedPartsList(products: controller.savedParts),
                  ),
                  const SliverToBoxAdapter(
                    child: _SectionHeader(title: 'Recent Alerts'),
                  ),
                  SliverToBoxAdapter(
                    child: _RecentAlertsList(alerts: controller.recentAlerts),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final AlertsController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Alerts',
                  variant: AppTextVariant.title,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColor.kTextPrimary,
                ),
                const SizedBox(height: 2),
                AppText(
                  controller.errorMessage.value.isEmpty
                      ? 'Price drops, saved parts, and compatibility updates'
                      : controller.errorMessage.value,
                  variant: AppTextVariant.caption,
                  fontSize: 12,
                  color: controller.errorMessage.value.isEmpty
                      ? AppColor.kTextSecondary
                      : AppColor.kError,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.controller});

  final AlertsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: AppColor.kSurface,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: AppColor.kBorder,
          width: AppColor.kBorderWidth,
        ),

        boxShadow: [
          BoxShadow(
            color: AppColor.kShadow.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: IntrinsicHeight(
        child: Row(
          children: [

            Expanded(
              child: _MetricTile(
                icon: Icons.trending_down_rounded,
                label: 'Drops',
                value: controller.priceDrops.length.toString(),
                color: AppColor.kGoogleBlue,
              ),
            ),

            const VerticalDivider(
              thickness: 0.1,
              width: 1,
            ),

            Expanded(
              child: _MetricTile(
                icon: Icons.check_circle_rounded,
                label: 'Fits',
                value: controller.compatibleCount.toString(),
                color: AppColor.kSuccess,
              ),
            ),

            const VerticalDivider(
              thickness: 0.1,
              width: 1,
            ),

            Expanded(
              child: _MetricTile(
                icon: Icons.bookmark_rounded,
                label: 'Saved',
                value: controller.savedParts.length.toString(),
                color: AppColor.kGoogleYellow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          AppText(
            value,
            variant: AppTextVariant.body,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColor.kTextPrimary,
          ),
          AppText(
            label,
            variant: AppTextVariant.caption,
            fontSize: 11,
            color: AppColor.kTextSecondary,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 68, color: AppColor.kBorder);
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action});

  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: AppText(
              title,
              variant: AppTextVariant.title,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.kTextSecondary,
            ),
          ),
          if (action != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColor.kGoogleBlue.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(999),
              ),
              child: AppText(
                action!,
                variant: AppTextVariant.body,
                fontSize: 10,
                color: AppColor.kGoogleBlue,
              ),
            ),
        ],
      ),
    );
  }
}

class _PriceWatchList extends StatelessWidget {
  const _PriceWatchList({required this.products});

  final List<AlertProduct> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const _EmptyState(
        icon: Icons.trending_flat_rounded,
        title: 'No price drops yet',
        subtitle: 'Pull down to refresh the latest listings.',
      );
    }

    return SizedBox(
      height: 214,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) => _PriceWatchCard(product: products[index]),
      ),
    );
  }
}

class _PriceWatchCard extends StatelessWidget {
  const _PriceWatchCard({required this.product});

  final AlertProduct product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164,
      decoration: BoxDecoration(
        color: AppColor.kSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColor.kBorder,
          width: AppColor.kBorderWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              _ProductImage(imageUrl: product.imageUrl, height: 112),
              if (product.dropPercent != null)
                Positioned(
                  left: 10,
                  top: 10,
                  child: Row(
                    children: [

                      _Badge(
                        text: '-${product.dropPercent}%',
                        color: Colors.transparent,
                      ),
                      SvgPicture.asset(
                        'assets/icons/trending-down.svg',
                        width: 15,
                        height: 15,
                        colorFilter: ColorFilter.mode(
                            AppColor.kGoogleRed.withValues(alpha: 0.75), BlendMode.srcIn),
                      ),
                    ],
                  ),
                ),
              // if (product.isCompatible)
              //   Positioned(
              //     right: 10,
              //     top: 10,
              //     child: _Badge(text: 'Fits', color: Colors.transparent),
              //   ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                AppText(
                  product.name,
                  variant: AppTextVariant.body,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: AppColor.kTextPrimary,
                ),
                const SizedBox(height: 2),
                AppText(
                  product.shopName,
                  variant: AppTextVariant.body,
                  fontSize: 10,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: AppColor.kTextSecondary,
                ),
                Divider(
                  thickness: 0.1,
                  color: AppColor.kGoogleBlue,
                ),

                Row(
                  children: [
                    AppText(
                      product.priceText,
                      variant: AppTextVariant.body,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColor.kTextPrimary,
                    ),
                    const SizedBox(width: 6),
                    if (product.oldPriceText != null)
                      Expanded(
                        child: AppText(
                          product.oldPriceText!,
                          variant: AppTextVariant.body,
                          fontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          decoration: TextDecoration.lineThrough,
                          color: AppColor.kGoogleRed,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedPartsList extends StatelessWidget {
  const _SavedPartsList({required this.products});

  final List<AlertProduct> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const _EmptyState(
        icon: Icons.bookmark_border_rounded,
        title: 'No saved parts loaded',
        subtitle: 'Saved endpoints will appear here when available.',
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.kSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColor.kBorder,
          width: AppColor.kBorderWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < products.length; index++)
            _SavedPartRow(
              product: products[index],
              showDivider: index != products.length - 1,
            ),
        ],
      ),
    );
  }
}

class _SavedPartRow extends StatelessWidget {
  const _SavedPartRow({required this.product, required this.showDivider});

  final AlertProduct product;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: _ProductImage(imageUrl: product.imageUrl, height: 52),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      product.name,
                      variant: AppTextVariant.body,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: AppColor.kTextPrimary,
                    ),
                    const SizedBox(height: 3),
                    AppText(
                      product.isCompatible
                          ? 'Compatible with your saved laptop'
                          : product.shopName,
                      variant: AppTextVariant.body,
                      fontSize: 10,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: product.isCompatible
                          ? AppColor.kSuccess
                          : AppColor.kTextSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              AppText(
                product.priceText,
                variant: AppTextVariant.body,
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: AppColor.kTextSecondary,
              ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 76, right: 12),
            child: Divider(height: 1, color: AppColor.kBorder),
          ),
      ],
    );
  }
}

class _RecentAlertsList extends StatelessWidget {
  const _RecentAlertsList({required this.alerts});

  final List<AlertItem> alerts;

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const _EmptyState(
        icon: Icons.notifications_none_rounded,
        title: 'Nothing new',
        subtitle: 'New backend alerts will show up here.',
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.kSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColor.kBorder,
          width: AppColor.kBorderWidth,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < alerts.length; index++)
            _AlertRow(
              alert: alerts[index],
              showDivider: index != alerts.length - 1,
            ),
        ],
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  const _AlertRow({required this.alert, required this.showDivider});

  final AlertItem alert;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final color = _kindColor(alert.kind);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(_kindIcon(alert.kind), color: color, size: 21),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AppText(
                                alert.title,
                                variant: AppTextVariant.body,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                color: AppColor.kTextPrimary,
                              ),
                            ),
                            if (alert.isUnread)
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: AppColor.kGoogleBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        AppText(
                          _alertSubtitle(alert),
                          variant: AppTextVariant.body,
                          fontSize: 11,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color: AppColor.kTextSecondary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            if (showDivider)
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Divider(height: 1, color: AppColor.kBorder),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl, required this.height});

  final String imageUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isNetwork = imageUrl.startsWith('http');
    final fallback = Container(
      height: height,
      width: double.infinity,
      color: AppColor.kBackground,
      child: Icon(
        Icons.memory_rounded,
        color: AppColor.kTextSecondary,
        size: height * 0.40,
      ),
    );

    if (isNetwork) {
      return Image.network(
        imageUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    }

    return Image.asset(
      imageUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => fallback,
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal : 2 , vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: AppText(
        text,
        variant: AppTextVariant.body,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColor.kGoogleRed.withValues(alpha: 0.75),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      decoration: BoxDecoration(
        color: AppColor.kSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColor.kBorder,
          width: AppColor.kBorderWidth,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColor.kTextSecondary, size: 32),
          const SizedBox(height: 10),
          AppText(
            title,
            variant: AppTextVariant.body,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColor.kTextPrimary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          AppText(
            subtitle,
            variant: AppTextVariant.caption,
            fontSize: 11,
            color: AppColor.kTextSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 120),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

IconData _kindIcon(AlertKind kind) {
  switch (kind) {
    case AlertKind.priceDrop:
      return Icons.trending_down_rounded;
    case AlertKind.compatibility:
      return Icons.check_circle_outline_rounded;
    case AlertKind.savedPart:
      return Icons.bookmark_border_rounded;
    case AlertKind.shop:
      return Icons.storefront_rounded;
    case AlertKind.system:
      return Icons.info_outline_rounded;
  }
}

Color _kindColor(AlertKind kind) {
  switch (kind) {
    case AlertKind.priceDrop:
      return AppColor.kGoogleBlue;
    case AlertKind.compatibility:
      return AppColor.kSuccess;
    case AlertKind.savedPart:
      return AppColor.kGoogleYellow;
    case AlertKind.shop:
      return AppColor.kGoogleGreen;
    case AlertKind.system:
      return AppColor.kTextPrimary;
  }
}

String _alertSubtitle(AlertItem alert) {
  final time = _relativeTime(alert.createdAt);
  if (time.isEmpty) return alert.subtitle;
  return '${alert.subtitle} • $time';
}

String _relativeTime(DateTime? date) {
  if (date == null) return '';
  final diff = DateTime.now().difference(date.toLocal());
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return '${date.day}/${date.month}/${date.year}';
}
