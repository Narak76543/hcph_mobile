import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_assgn/core/network/api_client.dart';
import 'package:school_assgn/core/session/session_service.dart';
import 'package:school_assgn/features/home/models/home_models.dart';
import 'package:school_assgn/themes/app_color.dart';

class PostReactionButtons extends StatefulWidget {
  final PostModel post;

  const PostReactionButtons({super.key, required this.post});

  @override
  State<PostReactionButtons> createState() => _PostReactionButtonsState();
}

class _PostReactionButtonsState extends State<PostReactionButtons>
    with TickerProviderStateMixin {
  final ApiClient _apiClient = ApiClient();

  bool _liked = false;
  bool _bookmarked = false;
  bool _copied = false;
  bool _isBusy = false;

  int _likeCount = 0;
  int _saveCount = 0;
  int _shareCount = 0;
  String? _linkUrl;

  late AnimationController _flameCtrl;
  late AnimationController _bookmarkCtrl;
  late AnimationController _shareCtrl;

  late Animation<double> _flameScale;
  late Animation<double> _bookmarkScale;
  late Animation<double> _shareScale;

  @override
  void initState() {
    super.initState();

    _flameCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _flameScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.5), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _flameCtrl, curve: Curves.easeOut));

    _bookmarkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _bookmarkScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _bookmarkCtrl, curve: Curves.easeOut));

    _shareCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _shareScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _shareCtrl, curve: Curves.easeOut));

    _loadEngagement();
  }

  @override
  void didUpdateWidget(covariant PostReactionButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.id != widget.post.id) {
      _liked = false;
      _bookmarked = false;
      _copied = false;
      _likeCount = 0;
      _saveCount = 0;
      _shareCount = 0;
      _linkUrl = null;
      _loadEngagement();
    }
  }

  @override
  void dispose() {
    _flameCtrl.dispose();
    _bookmarkCtrl.dispose();
    _shareCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────
  // Handlers
  // ─────────────────────────────────────────────────────────────

  Future<void> _loadEngagement() async {
    if (widget.post.id.isEmpty) return;
    try {
      final response = await _apiClient.getRequest(
        '/listings/${widget.post.id}/engagement',
        bearerToken: _accessToken,
      );
      if (!mounted) return;
      _applyEngagement(response);
    } catch (_) {
      // Keep the buttons usable with zero counts if the backend is unavailable.
    }
  }

  Future<void> _onFlameTap() async {
    if (_isBusy) return;
    final token = _accessToken;
    if (token == null || token.isEmpty) {
      _showMessage('Please sign in to react to posts.');
      return;
    }

    HapticFeedback.lightImpact();
    _flameCtrl.forward(from: 0);
    setState(() => _isBusy = true);

    try {
      final response = await _apiClient.postJson(
        '/listings/${widget.post.id}/react',
        body: const {},
        bearerToken: token,
      );
      if (!mounted) return;
      _applyEngagement(response);
    } catch (_) {
      _showMessage('Could not update reaction. Try again.');
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _onBookmarkTap() async {
    if (_isBusy) return;
    final token = _accessToken;
    if (token == null || token.isEmpty) {
      _showMessage('Please sign in to save posts.');
      return;
    }

    HapticFeedback.lightImpact();
    _bookmarkCtrl.forward(from: 0);
    setState(() => _isBusy = true);

    try {
      final response = await _apiClient.postJson(
        '/listings/${widget.post.id}/save',
        body: const {},
        bearerToken: token,
      );
      if (!mounted) return;
      _applyEngagement(response);
    } catch (_) {
      _showMessage('Could not update saved post. Try again.');
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _onShareTap() async {
    HapticFeedback.lightImpact();
    _shareCtrl.forward(from: 0);

    var link = _linkUrl ?? 'https://hcph.app/parts/${widget.post.id}';

    try {
      final response = await _apiClient.postJson(
        '/listings/${widget.post.id}/share',
        body: const {},
        bearerToken: _accessToken,
      );
      _applyEngagement(response);
      final responseLink = response['link_url']?.toString();
      if (responseLink != null && responseLink.trim().isNotEmpty) {
        link = responseLink;
      }
    } catch (_) {
      // Copy still succeeds even when the analytics endpoint is unavailable.
    }

    await Clipboard.setData(ClipboardData(text: link));

    if (!mounted) return;

    setState(() {
      _copied = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        _copied = false;
      });
    });
  }

  void _applyEngagement(dynamic response) {
    if (response is! Map) return;
    setState(() {
      _liked = response['reacted'] == true;
      _bookmarked = response['saved'] == true;
      _likeCount = _parseInt(response['reaction_count']);
      _saveCount = _parseInt(response['save_count']);
      _shareCount = _parseInt(response['share_count']);
      _linkUrl = response['link_url']?.toString();
    });
  }

  int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String? get _accessToken {
    try {
      return Get.find<SessionService>().accessToken;
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: 210,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // ============ Flame ===========================
            GestureDetector(
              onTap: _onFlameTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _flameScale,
                      child: SvgPicture.asset(
                        _liked
                            ? 'assets/icons/fire-flame-curved-solid-full.svg'
                            : 'assets/icons/flame.svg',
                        width: 22,
                        height: 22,
                        colorFilter: ColorFilter.mode(
                          _liked
                              ? const Color(0xFFFF6B2C)
                              : AppColor.kGoogleBlue.withValues(alpha: 0.4),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),

                    _ActionCount(
                      count: _likeCount,
                      active: _liked,
                      activeColor: AppColor.kGoogleRed,
                    ),
                  ],
                ),
              ),
            ),

            // =========== Bookmark ==========================
            GestureDetector(
              onTap: _onBookmarkTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _bookmarkScale,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: SvgPicture.asset(
                          _bookmarked
                              ? 'assets/icons/bookmark-solid-full.svg'
                              : 'assets/icons/bookmark-regular-full.svg',
                          key: ValueKey(_bookmarked),
                          width: 22,
                          height: 22,
                          colorFilter: ColorFilter.mode(
                            _bookmarked
                                ? AppColor.kGoogleBlue
                                : AppColor.kGoogleBlue.withValues(alpha: 0.4),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    _ActionCount(
                      count: _saveCount,
                      active: _bookmarked,
                      activeColor: AppColor.kGoogleBlue,
                    ),
                  ],
                ),
              ),
            ),

            // ======== Share Button ========
            GestureDetector(
              onTap: _onShareTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _shareScale,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: SvgPicture.asset(
                          _copied
                              ? 'assets/icons/link-solid-full.svg'
                              : 'assets/icons/link-2.svg',
                          key: ValueKey(_copied),
                          width: 22,
                          height: 22,
                          colorFilter: ColorFilter.mode(
                            _copied
                                ? AppColor.kGoogleBlue
                                : AppColor.kGoogleBlue.withValues(alpha: 0.4),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    _ActionCount(
                      count: _shareCount,
                      active: _copied,
                      activeColor: AppColor.kGoogleBlue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCount extends StatelessWidget {
  const _ActionCount({
    required this.count,
    required this.active,
    required this.activeColor,
  });

  final int count;
  final bool active;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: active ? activeColor : AppColor.kTextSecondary,
        ),
        child: Text(_compactCount(count)),
      ),
    );
  }

  String _compactCount(int value) {
    if (value < 1000) return value.toString();
    final compact = value / 1000;
    return '${compact.toStringAsFixed(compact >= 10 ? 0 : 1)}k';
  }
}
