import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:school_assgn/core/network/api_client.dart';
import 'package:school_assgn/core/session/session_service.dart';
import 'package:school_assgn/features/home/models/home_models.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/reacttion_button.dart';
import 'package:school_assgn/widget/text_widget.dart';
import 'package:school_assgn/widget/three_dot_button.dart';

class ShowingCard extends StatelessWidget {
  const ShowingCard({super.key, this.laptopName});

  final String? laptopName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.kGoogleBlue.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppColor.kCardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/astroid.svg',
              width: 15,
              height: 15,
              colorFilter: ColorFilter.mode(
                AppColor.kGoogleBlue,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
            AppText(
              'Showing parts for ${laptopName ?? 'your device'}',
              color: AppColor.kGoogleBlue,
              fontSize: 13,
            ),
          ],
        ),
      ),
    );
  }
}

class SearchProductCard extends StatelessWidget {
  const SearchProductCard({
    super.key,
    required this.post,
    required this.fitsYourDevice,
  });

  final PostModel post;
  final bool fitsYourDevice;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColor.kSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColor.kBorder),
            boxShadow: [
              BoxShadow(
                color: AppColor.kShadow,
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Row(
                  children: [
                    _OwnerAvatar(imageUrl: post.ownerProfileImageUrl),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: AppText(
                                  post.ownerFullName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 12,
                                  color: AppColor.kGoogleBlue,
                                ),
                              ),
                              SvgPicture.asset(
                                width: 13,
                                height: 13,
                                'assets/icons/chevron-right.svg',
                              ),
                              Flexible(
                                child: AppText(
                                  post.shopName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          if (post.formattedPostedDate.isNotEmpty)
                            AppText(
                              post.formattedPostedDate,
                              fontSize: 10,
                              color: AppColor.kTextSecondary,
                            ),
                        ],
                      ),
                    ),
                    _FollowTechnicalButton(post: post),
                    const SizedBox(width: 8),
                    ThreeDotButton(onTap: () {}, post: post),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: AppColor.kBorder, height: 1),
              ),

              _SearchCardImage(
                imageUrl: post.imageUrl,
                fitsYourDevice: fitsYourDevice,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      post.brand.isNotEmpty
                          ? post.brand.toUpperCase()
                          : 'PREMIUM',
                      color: AppColor.kGoogleBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),

                    const SizedBox(height: 4),
                    AppText(
                      post.partName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      _specLine(post),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 11,
                      color: AppColor.kTextSecondary.withValues(alpha: 0.82),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: AppColor.kBorder, height: 1),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/shopping-bag.svg',
                          width: 13,
                          height: 13,
                          colorFilter: ColorFilter.mode(
                            AppColor.kTextSecondary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppText(
                            post.shopName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 11,
                            color: AppColor.kTextSecondary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        _PricePill(price: post.price),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/user-round.svg',
                          width: 13,
                          height: 13,
                          colorFilter: ColorFilter.mode(
                            AppColor.kTextSecondary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppText(
                            post.ownerFullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 11,
                            color: AppColor.kTextSecondary,
                          ),
                        ),
                        if (fitsYourDevice) const _FitPill(),
                      ],
                    ),
                  ],
                ),
              ),
              PostReactionButtons(post: post),
            ],
          ),
        ),
      ],
    );
  }

  String _specLine(PostModel post) {
    final specs = post.partSpecs;
    final pieces = <String>[];

    final type =
        specs['ssd_type'] ?? specs['ram_type'] ?? specs['battery_type'];
    final capacity = specs['capacity_gb'];
    final readSpeed = specs['read_speed_mbps'];

    if (type != null && type.toString().isNotEmpty) pieces.add(type.toString());
    if (capacity != null && capacity.toString().isNotEmpty) {
      pieces.add('${capacity}GB');
    }
    if (readSpeed != null && readSpeed.toString().isNotEmpty) {
      pieces.add('Read ${readSpeed}MB/s');
    }

    if (pieces.isNotEmpty) return pieces.join(' · ');
    if (post.compatibleModel.isNotEmpty) return post.compatibleModel;
    return post.model.isNotEmpty ? post.model : 'Compatible hardware part';
  }
}

class _FollowTechnicalButton extends StatefulWidget {
  const _FollowTechnicalButton({required this.post});

  final PostModel post;

  @override
  State<_FollowTechnicalButton> createState() => _FollowTechnicalButtonState();
}

class _FollowTechnicalButtonState extends State<_FollowTechnicalButton> {
  final ApiClient _apiClient = ApiClient();

  bool _isFollowing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  @override
  void didUpdateWidget(covariant _FollowTechnicalButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.ownerUserId != widget.post.ownerUserId) {
      _isFollowing = false;
      _loadStatus();
    }
  }

  bool get _canShow {
    final ownerId = widget.post.ownerUserId?.trim() ?? '';
    if (ownerId.isEmpty) return false;
    if (ownerId == _currentUserId) return false;
    return widget.post.ownerRole.toLowerCase() == 'technical';
  }

  Future<void> _loadStatus() async {
    if (!_canShow) return;
    try {
      final response = await _apiClient.getRequest(
        '/users/${widget.post.ownerUserId}/follow-status',
        bearerToken: _accessToken,
      );
      if (!mounted) return;
      _applyStatus(response);
    } catch (_) {}
  }

  Future<void> _toggleFollow() async {
    if (_isLoading || !_canShow) return;
    final token = _accessToken;
    if (token == null || token.isEmpty) {
      _showMessage('Please sign in to follow technical users.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _apiClient.postJson(
        '/users/${widget.post.ownerUserId}/follow',
        body: const {},
        bearerToken: token,
      );
      if (!mounted) return;
      _applyStatus(response);
    } catch (_) {
      _showMessage('Could not update follow. Try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _applyStatus(dynamic response) {
    if (response is! Map) return;
    setState(() {
      _isFollowing = response['is_following'] == true;
    });
  }

  String? get _accessToken {
    try {
      return Get.find<SessionService>().accessToken;
    } catch (_) {
      return null;
    }
  }

  String? get _currentUserId {
    try {
      return Get.find<SessionService>().userId;
    } catch (_) {
      return null;
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_canShow) return const SizedBox.shrink();

    final label = _isFollowing ? 'Following' : 'Follow';

    return GestureDetector(
      onTap: _toggleFollow,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _isFollowing ? AppColor.kGoogleBlue : AppColor.kSurface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: _isFollowing ? AppColor.kGoogleBlue : AppColor.kBorder,
            width: AppColor.kBorderWidth,
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _isFollowing ? Colors.white : AppColor.kGoogleBlue,
                ),
              )
            : AppText(
                label,
                variant: AppTextVariant.label,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: _isFollowing ? Colors.white : AppColor.kGoogleBlue,
              ),
      ),
    );
  }
}

class _OwnerAvatar extends StatelessWidget {
  const _OwnerAvatar({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColor.kGoogleBlue,
        shape: BoxShape.circle,
      ),
      child: imageUrl.startsWith('http')
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            )
          : imageUrl.startsWith('assets/')
          ? Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _SearchCardImage extends StatelessWidget {
  const _SearchCardImage({
    required this.imageUrl,
    required this.fitsYourDevice,
  });

  final String imageUrl;
  final bool fitsYourDevice;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: const Color(0xFFEFF4F8),
            child: imageUrl.startsWith('http')
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const _ImageFallback(),
                  )
                : Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const _ImageFallback(),
                  ),
          ),
          Positioned(
            left: 14,
            top: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              decoration: BoxDecoration(
                color: fitsYourDevice
                    ? AppColor.kGoogleGreen.withValues(alpha: 0.35)
                    : Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(18),
              ),
              child: AppText(
                fitsYourDevice ? 'NEW' : 'PART',
                fontSize: 10,
                color: AppColor.kGoogleGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('assets/images/ss990.webp', fit: BoxFit.contain),
    );
  }
}

class _PricePill extends StatelessWidget {
  const _PricePill({required this.price});

  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColor.kGoogleBlue,
        borderRadius: BorderRadius.circular(AppColor.kCardRadius),
      ),
      child: AppText(
        '\$${price.toStringAsFixed(price.truncateToDouble() == price ? 0 : 2)}',
        color: AppColor.kAccent,
        fontSize: 12,
      ),
    );
  }
}

class _FitPill extends StatelessWidget {
  const _FitPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFE8FFF0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppColor.kGoogleGreen,
            size: 14,
          ),
          SizedBox(width: 5),
          Text(
            'Fits your device',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: AppColor.kGoogleGreen,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
