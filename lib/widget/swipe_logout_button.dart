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
          height: 62,
          width: maxWidth,
          decoration: BoxDecoration(
            color: AppColor.kSurface.withOpacity(0.8),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: AppColor.kTextSecondary.withOpacity(0.1),
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
                          AppColor.kError.withOpacity(0.7),
                          AppColor.kError.withOpacity(0.4),
                          AppColor.kError.withOpacity(0.7),
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
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // The Handle Target Area (Track Background)
              Positioned(
                left: padding,
                top: padding,
                bottom: padding,
                width: currentPosition + handleSize,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.kError.withOpacity(0.15),
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.logout_rounded,
                      color: AppColor.kError,
                      size: 24,
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
