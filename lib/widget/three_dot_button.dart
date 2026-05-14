import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_assgn/features/home/models/home_models.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ThreeDotButton extends StatelessWidget {
  final VoidCallback onTap;
  final PostModel? post;
  const ThreeDotButton({super.key, required this.onTap, this.post});

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

        if (!context.mounted) return;

        switch (selected) {
          case 'direct_contact':
            await _openTelegram(context);
            break;

          case 'go_to_shop':
            await _openShopMap(context);
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

  Future<void> _openTelegram(BuildContext context) async {
    final username = _normalizeTelegramUsername(
      post?.ownerTelegramUsername.isNotEmpty == true
          ? post!.ownerTelegramUsername
          : post?.shopTelegramHandle ?? '',
    );

    if (username.isEmpty) {
      _showMessage(context, 'Telegram contact is not available.');
      return;
    }

    final uri = Uri.parse('https://t.me/$username');
    await _launchExternal(context, uri, 'Could not open Telegram.');
  }

  Future<void> _openShopMap(BuildContext context) async {
    final url = post?.shopGoogleMapsUrl.trim() ?? '';
    if (url.isEmpty) {
      _showMessage(context, 'Shop map location is not available.');
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      _showMessage(context, 'Shop map location is invalid.');
      return;
    }

    await _launchExternal(context, uri, 'Could not open Google Maps.');
  }

  Future<void> _launchExternal(
    BuildContext context,
    Uri uri,
    String errorMessage,
  ) async {
    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      return;
    }

    if (!context.mounted) return;
    _showMessage(context, errorMessage);
  }

  String _normalizeTelegramUsername(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';

    final uri = Uri.tryParse(trimmed);
    if (uri != null && uri.host.toLowerCase().contains('t.me')) {
      final username = uri.pathSegments.isEmpty ? '' : uri.pathSegments.first;
      return username.replaceFirst(RegExp(r'^@+'), '');
    }
    if (uri != null && uri.scheme == 'tg') {
      return uri.queryParameters['domain']?.trim() ?? '';
    }

    return trimmed.replaceFirst(RegExp(r'^@+'), '');
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
