import 'package:flutter/material.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class SwipeLogoutButton extends StatefulWidget {
  final VoidCallback onLogout;
  const SwipeLogoutButton({super.key, required this.onLogout});

  @override
  State<SwipeLogoutButton> createState() => _SwipeLogoutButtonState();
}

class _SwipeLogoutButtonState extends State<SwipeLogoutButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragValue = 0.0;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, double maxWidth) {
    if (_isFinished) return;
    setState(() {
      _dragValue += details.primaryDelta! / (maxWidth - 60);
      if (_dragValue < 0) _dragValue = 0;
      if (_dragValue > 1) _dragValue = 1;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isFinished) return;
    if (_dragValue > 0.8) {
      setState(() {
        _dragValue = 1.0;
        _isFinished = true;
      });
      widget.onLogout();
    } else {
      setState(() {
        _dragValue = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double handleSize = 54.0;
        final double padding = 4.0;
        final double availableWidth = maxWidth - handleSize - (padding * 2);
        final double currentPosition = _dragValue * availableWidth;

        return Container(
          height: 64,
          width: maxWidth,
          decoration: BoxDecoration(
            color: AppColor.kAuthSurface,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: AppColor.kGoogleRed.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // Animated Text (Pulsing color)
              Center(
                child: Opacity(
                  opacity: 1.0 - (_dragValue * 0.8),
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          AppColor.kGoogleRed.withValues(alpha: 0.8),
                          AppColor.kGoogleRed.withValues(alpha: 0.4),
                          AppColor.kGoogleRed.withValues(alpha: 0.8),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: const AppText(
                      'Swipe to logout',
                      variant: AppTextVariant.body,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // The Handle Target Area (Active Track)
              Positioned(
                left: padding,
                top: padding,
                bottom: padding,
                width: currentPosition + handleSize,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.kGoogleRed.withValues(alpha: 0.15),
                        AppColor.kGoogleRed.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),

              // The draggable handle
              Positioned(
                left: padding + currentPosition,
                top: padding,
                bottom: padding,
                child: GestureDetector(
                  onHorizontalDragUpdate: (d) =>
                      _onHorizontalDragUpdate(d, maxWidth),
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Container(
                    width: handleSize,
                    height: handleSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.kGoogleRed.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.logout_rounded,
                        color: AppColor.kGoogleRed,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
