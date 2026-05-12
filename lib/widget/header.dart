import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/menu1.svg',
            colorFilter: ColorFilter.mode(
              AppColor.kAuthAccent, 
              BlendMode.srcIn
              ),
            ),
            const SizedBox(width: 10), 
            AppText(
              'Hardware Hub',
              variant: AppTextVariant.body,
            ),
            const Spacer(),
            Container(
              width: 40, 
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.kGoogleBlue, 
                borderRadius: BorderRadius.circular(23)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/shopping-cart.svg',
                  colorFilter: ColorFilter.mode(
                    AppColor.kAccent, 
                    BlendMode.srcIn
                    ),
                ),
              ),
              
            )
        ],
      ),
    );
  }
}