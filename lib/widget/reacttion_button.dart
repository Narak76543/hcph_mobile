// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:school_assgn/features/home/models/home_models.dart';
// import 'package:school_assgn/themes/app_color.dart';

// class PostReactionButtons extends StatefulWidget {
//   final PostModel post;

//   const PostReactionButtons({super.key, required this.post});

//   @override
//   State<PostReactionButtons> createState() => _PostReactionButtonsState();
// }

// class _PostReactionButtonsState extends State<PostReactionButtons>
//     with TickerProviderStateMixin {
//   bool _liked = false;
//   bool _bookmarked = false;
//   int _likeCount = 0;

//   late AnimationController _flameCtrl;
//   late AnimationController _bookmarkCtrl;
//   late AnimationController _shareCtrl;

//   late Animation<double> _flameScale;
//   late Animation<double> _bookmarkScale;
//   late Animation<double> _shareScale;

//   @override
//   void initState() {
//     super.initState();

//     _flameCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _flameScale = TweenSequence([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.5), weight: 40),
//       TweenSequenceItem(tween: Tween(begin: 1.5, end: 0.9), weight: 30),
//       TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
//     ]).animate(CurvedAnimation(parent: _flameCtrl, curve: Curves.easeOut));

//     _bookmarkCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _bookmarkScale = TweenSequence([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 40),
//       TweenSequenceItem(tween: Tween(begin: 1.4, end: 0.9), weight: 30),
//       TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
//     ]).animate(CurvedAnimation(parent: _bookmarkCtrl, curve: Curves.easeOut));

//     _shareCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 200),
//     );
//     _shareScale = TweenSequence([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
//       TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
//     ]).animate(CurvedAnimation(parent: _shareCtrl, curve: Curves.easeOut));
//   }

//   @override
//   void dispose() {
//     _flameCtrl.dispose();
//     _bookmarkCtrl.dispose();
//     _shareCtrl.dispose();
//     super.dispose();
//   }

//   // ── Handlers

//   void _onFlameTap() {
//     HapticFeedback.lightImpact();
//     setState(() {
//       _liked = !_liked;
//       _likeCount += _liked ? 1 : -1;
//     });
//     _flameCtrl.forward(from: 0);
//   }

//   void _onBookmarkTap() {
//     HapticFeedback.lightImpact();
//     setState(() => _bookmarked = !_bookmarked);
//     _bookmarkCtrl.forward(from: 0);
//   }

//   bool _copied = false;

//   Future<void> _onShareTap() async {
//     HapticFeedback.lightImpact();

//     await Clipboard.setData(
//       ClipboardData(text: 'https://hcph.app/parts/${widget.post.id}'),
//     );

//     _shareCtrl.forward(from: 0);

//     if (!mounted) return;

//     setState(() {
//       _copied = true;
//     });

//     Future.delayed(const Duration(seconds: 1), () {
//       if (!mounted) return;

//       setState(() {
//         _copied = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15.0),
//       child: SizedBox(
//         width: 160,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             // ── Flame
//             GestureDetector(
//               onTap: _onFlameTap,
//               behavior: HitTestBehavior.opaque,
//               child: Padding(
//                 padding: const EdgeInsets.all(6),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     ScaleTransition(
//                       scale: _flameScale,
//                       child: SvgPicture.asset(
//                         'assets/icons/flame.svg',
//                         width: 22,
//                         height: 22,
//                         colorFilter: ColorFilter.mode(
//                           _liked
//                               ? const Color(0xFFFF6B2C)
//                               : AppColor.kGoogleBlue.withValues(alpha: 0.4),
//                           BlendMode.srcIn,
//                         ),
//                       ),
//                     ),
//                     if (_likeCount > 0) ...[
//                       const SizedBox(height: 2),
//                       AnimatedDefaultTextStyle(
//                         duration: const Duration(milliseconds: 200),
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontSize: 10,
//                           fontWeight: FontWeight.w500,
//                           color: _liked
//                               ? AppColor.kGoogleRed
//                               : AppColor.kTextSecondary,
//                         ),
//                         child: Text('$_likeCount'),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),

//             // ── Bookmark ─────────────────────────────────────────────────
//             GestureDetector(
//               onTap: _onBookmarkTap,
//               behavior: HitTestBehavior.opaque,
//               child: Padding(
//                 padding: const EdgeInsets.all(6),
//                 child: ScaleTransition(
//                   scale: _bookmarkScale,
//                   child: SvgPicture.asset(
//                     'assets/icons/bookmark.svg',
//                     width: 22,
//                     height: 22,
//                     colorFilter: ColorFilter.mode(
//                       _bookmarked
//                           ? AppColor.kGoogleBlue
//                           : AppColor.kGoogleBlue.withValues(alpha: 0.4),
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // ── Share ─────────────────────────────────────────────────────
//             GestureDetector(
//               onTap: _onShareTap,
//               behavior: HitTestBehavior.opaque,
//               child: Padding(
//                 padding: const EdgeInsets.all(6),
//                 child: ScaleTransition(
//                   scale: _shareScale,
//                   child: SvgPicture.asset(
//                     'assets/icons/link-2.svg',
//                     width: 22,
//                     height: 22,
//                     colorFilter: ColorFilter.mode(
//                       AppColor.kGoogleBlue.withValues(alpha: 0.4),
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  bool _liked = false;
  bool _bookmarked = false;
  bool _copied = false;

  int _likeCount = 0;

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

  void _onFlameTap() {
    HapticFeedback.lightImpact();

    setState(() {
      _liked = !_liked;
      _likeCount += _liked ? 1 : -1;
    });

    _flameCtrl.forward(from: 0);
  }

  void _onBookmarkTap() {
    HapticFeedback.lightImpact();

    setState(() {
      _bookmarked = !_bookmarked;
    });

    _bookmarkCtrl.forward(from: 0);
  }

  Future<void> _onShareTap() async {
    HapticFeedback.lightImpact();

    await Clipboard.setData(
      ClipboardData(text: 'https://hcph.app/parts/${widget.post.id}'),
    );

    _shareCtrl.forward(from: 0);

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: 160,
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

                    if (_likeCount > 0) ...[
                      const SizedBox(width: 4),

                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: _liked
                              ? AppColor.kGoogleRed
                              : AppColor.kTextSecondary,
                        ),
                        child: Text('$_likeCount'),
                      ),
                    ],
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
                child: ScaleTransition(
                  scale: _bookmarkScale,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
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
              ),
            ),

            // ======== Share Button ========
            GestureDetector(
              onTap: _onShareTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: ScaleTransition(
                  scale: _shareScale,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
