import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class ThreeDotButton extends StatelessWidget {
  final VoidCallback onTap;
  const ThreeDotButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) async {
        final selected = await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            details.globalPosition.dx,
            details.globalPosition.dy,
          ),
          color: AppColor.kSurface.withValues(alpha: 0.85),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          items: [
            PopupMenuItem(
              value: 'direct_contact',
              child: Row(
                children: [
                  SvgPicture.asset(
                    width: 15,
                    height: 15,
                    'assets/icons/phone-outgoing.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.kGoogleBlue,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 10),
                  AppText(
                    'Direct Contact',
                    variant: AppTextVariant.body,
                    color: AppColor.kGoogleBlue,
                    fontSize: 12,
                  ),
                ],
              ),
            ),

            PopupMenuItem(
              value: 'go_to_shop',
              child: Row(
                children: [
                  SvgPicture.asset(
                    width: 15,
                    height: 15,
                    'assets/icons/map-pin-check.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.kGoogleBlue,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 10),
                  AppText(
                    'Go to Shop',
                    variant: AppTextVariant.body,
                    color: AppColor.kGoogleBlue,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
          ],
        );

        switch (selected) {
          case 'direct_contact':
            print('direct contact clicked');
            break;

          case 'go_to_shop':
            print('go to shop clicked');
            break;
        }
      },

      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          'assets/icons/ellipsis-vertical (1).svg',
          width: 15,
          height: 15,
          colorFilter: ColorFilter.mode(
            AppColor.kTextSecondary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
