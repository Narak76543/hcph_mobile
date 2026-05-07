import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/core/theme/theme_service.dart';

class AppColor {
  AppColor._();

  // ── Branding Colors ──────────────────────────────────────────
  static const Color kGoogleBlue = Color(0xFF4285F4);
  static const Color kGoogleRed = Color(0xFFEA4335);
  static const Color kGoogleYellow = Color(0xFFFBBC05);
  static const Color kGoogleGreen = Color(0xFF34A853);
  static const Color kError = Color(0xFFEF4444);

  static const Color kAccent = Color(0xFFFFFFFF);
  static const Color kAccentLight = Color(0xFFB0B0B0);
  static const Color kLink = Color(0xFF4285F4);

  // ── Theme Getter ─────────────────────────────────────────────
  static bool get _isDark => Get.find<ThemeService>().isDarkMode.value;

  // ── Permanent AMOLED Stealth Palette / Light Palette ────────
  static Color get kBackground =>
      _isDark ? const Color(0xFF000000) : const Color(0xFFF2F2F7);
  static Color get kSurface =>
      _isDark ? const Color(0xFF161616) : const Color(0xFFFFFFFF);
  static Color get kBorder =>
      _isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE5E5EA);
  static Color get kOverlay =>
      _isDark ? const Color(0xCC000000) : const Color(0x99FFFFFF);
  static Color get kGlassBorder =>
      _isDark ? const Color(0x1AFFFFFF) : const Color(0x1A000000);
  static Color get kShadow =>
      _isDark ? Colors.transparent : const Color(0x1A000000);

  // ── Text Colors ─────────────────────────────────────────────
  static Color get kTextPrimary =>
      _isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  static Color get kTextSecondary =>
      _isDark ? const Color(0xFF737373) : const Color(0xFF8E8E93);

  // ── Navigation ──────────────────────────────────────────────
  static Color get kNavIcon =>
      _isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  static Color get kNavBarBackground => _isDark
      ? const Color(0xFF000000).withValues(alpha: 0.8)
      : const Color(0xFFFFFFFF).withValues(alpha: 0.8);
  static Color get kNavSelectedStart =>
      _isDark ? kAccent : const Color(0xFF000000);
  static Color get kNavSelectedEnd =>
      _isDark ? kAccentLight : const Color(0xFF8E8E93);

  // ── Layout Constants ────────────────────────────────────────
  static const double kCardRadius = 32.0;
  static const double kBorderWidth = 0.5;

  // ── Functional & Legacy Aliases ────────────────────────────
  static Color get kOnAccent => _isDark ? Colors.black : Colors.white;
  static Color get kBgColor => kBackground;
  static Color get kAuthSurface => kSurface;
  static Color get kAuthBorder => kBorder;
  static Color get kAuthAccent =>
      _isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  static Color get kAuthTextPrimary => kTextPrimary;
  static Color get kAuthTextSecondary => kTextSecondary;

  // Legacy compatibility aliases
  static Color get kPrimary =>
      _isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
  static Color get kAuthBackground => kBackground;
  static Color get kAuthBackgroundOverlay => kOverlay;
  static Color get kTextColor => kTextPrimary;
  static Color get kAuthLink => kLink;
  static Color get kNavPrimaryText => kTextPrimary;
}

class AppColors extends AppColor {
  AppColors._() : super._();

  static Color get textPrimary => AppColor.kTextPrimary;
  static Color get textSecondary => AppColor.kTextSecondary;
}

// ==================================
// Option 2 color
// ===================================
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:school_assgn/core/theme/theme_service.dart';

// class AppColor {
//   AppColor._();

//   // ── Branding ───────────────────────────────────────────────────────────
//   static const Color kGoogleBlue = Color(0xFF4285F4);
//   static const Color kGoogleRed = Color(0xFFEA4335);
//   static const Color kGoogleYellow = Color(0xFFFBBC05);
//   static const Color kGoogleGreen = Color(0xFF34A853);
//   static const Color kError = Color(0xFFEF4444);

//   // ── Accent (Warm Gold) ─────────────────────────────────────────────────
//   static const Color kAccent = Color(0xFFE8A450); // warm gold
//   static const Color kAccentLight = Color(0xFFF0BB78); // lighter gold
//   static const Color kAccentDark = Color(0xFFD08C3A); // deeper gold
//   static const Color kLink = Color(0xFFE8A450);

//   // ── Dark Palette (Charcoal Warm) ───────────────────────────────────────
//   // Warm brown-gray tones — cozy, premium, easy on the eyes
//   static const Color _darkBg = Color(0xFF1A1714); // deepest bg
//   static const Color _darkSurface = Color(0xFF242019); // cards, sheets
//   static const Color _darkCard = Color(0xFF2C271F); // elevated cards
//   static const Color _darkBorder = Color(0xFF332E28); // subtle borders
//   static const Color _darkInput = Color(0xFF2C271F); // input fields
//   static const Color _darkDivider = Color(0xFF3D3730); // dividers

//   // ── Light Palette ──────────────────────────────────────────────────────
//   static const Color _lightBg = Color(0xFFF7F4F0); // warm off-white
//   static const Color _lightSurface = Color(0xFFFFFFFF);
//   static const Color _lightCard = Color(0xFFFAF8F5);
//   static const Color _lightBorder = Color(0xFFE8E2D9);
//   static const Color _lightInput = Color(0xFFF5F1EB);

//   // ── Theme Getter ───────────────────────────────────────────────────────
//   static bool get _isDark => Get.find<ThemeService>().isDarkMode.value;

//   // ── Backgrounds ────────────────────────────────────────────────────────
//   static Color get kBackground => _isDark ? _darkBg : _lightBg;
//   static Color get kSurface => _isDark ? _darkSurface : _lightSurface;
//   static Color get kCard => _isDark ? _darkCard : _lightCard;
//   static Color get kBorder => _isDark ? _darkBorder : _lightBorder;
//   static Color get kDivider => _isDark ? _darkDivider : const Color(0xFFE8E2D9);

//   // ── Auth ───────────────────────────────────────────────────────────────
//   static Color get kAuthBackground => kBackground;
//   static Color get kAuthSurface => kSurface;
//   static Color get kAuthBorder => kBorder;
//   static Color get kAuthAccent => kAccent;

//   // ── Glassmorphism ──────────────────────────────────────────────────────
//   static Color get kOverlay => _isDark
//       ? const Color(0xFF1A1714).withOpacity(0.90)
//       : const Color(0xFFF7F4F0).withOpacity(0.92);

//   static Color get kGlassBorder => _isDark
//       ? const Color(0xFFFFFFFF).withOpacity(0.07)
//       : const Color(0xFF000000).withOpacity(0.06);

//   static Color get kShadow => _isDark
//       ? Colors.black.withOpacity(0.45)
//       : const Color(0xFF8B7355).withOpacity(0.08);

//   // ── Text ───────────────────────────────────────────────────────────────
//   static Color get kTextPrimary => _isDark
//       ? const Color(0xFFF0EDE8) // warm soft white
//       : const Color(0xFF1C1410); // deep warm brown

//   static Color get kTextSecondary => _isDark
//       ? const Color(0xFF9C9186) // warm muted gray
//       : const Color(0xFF7A6E63); // warm mid brown

//   static Color get kTextHint => _isDark
//       ? const Color(0xFF5C5249) // subtle warm hint
//       : const Color(0xFFB0A89E);

//   // ── Inputs ─────────────────────────────────────────────────────────────
//   static Color get kInputBg => _isDark ? _darkInput : _lightInput;
//   static Color get kInputBorder =>
//       _isDark ? const Color(0xFF3D3730) : const Color(0xFFD4CEC6);
//   static Color get kInputFocused => kAccent;

//   // ── Cards ──────────────────────────────────────────────────────────────
//   static Color get kCardBg => _isDark ? _darkCard : _lightCard;
//   static Color get kCardBorder => _isDark ? _darkBorder : _lightBorder;

//   // ── Navigation ─────────────────────────────────────────────────────────
//   static Color get kNavIcon =>
//       _isDark ? const Color(0xFF9C9186) : const Color(0xFF7A6E63);

//   static Color get kNavBarBackground => _isDark
//       ? const Color(0xFF242019).withOpacity(0.94)
//       : const Color(0xFFFFFFFF).withOpacity(0.94);

//   static Color get kNavSelectedStart => kAccent;
//   static Color get kNavSelectedEnd => kAccentDark;

//   // ── Status ─────────────────────────────────────────────────────────────
//   static Color get kSuccess =>
//       _isDark ? const Color(0xFF5EC97A) : const Color(0xFF2E9E50);
//   static Color get kWarning =>
//       _isDark ? const Color(0xFFE8A450) : const Color(0xFFD08C3A);
//   static Color get kDanger =>
//       _isDark ? const Color(0xFFE87070) : const Color(0xFFD03A3A);

//   // ── Badge / Tag ────────────────────────────────────────────────────────
//   static Color get kBadgeBg =>
//       _isDark ? const Color(0xFF3D3730) : const Color(0xFFF0E8DC);
//   static Color get kBadgeText =>
//       _isDark ? const Color(0xFFE8A450) : const Color(0xFFD08C3A);

//   // ── Misc / Legacy ──────────────────────────────────────────────────────
//   static Color get kOnAccent => const Color(0xFF1A1714); // dark text on gold
//   static Color get kPrimary => kAccent;
//   static Color get kSecondary => kTextSecondary;
//   static Color get kBgColor => kBackground;
//   static Color get kTextColor => kOnAccent;

//   // ── Auth Aliases ───────────────────────────────────────────────────────
//   static Color get kAuthTextPrimary => kTextPrimary;
//   static Color get kAuthTextSecondary => kTextSecondary;
//   static Color get kAuthLink => kLink;
//   static Color get kAuthBackgroundOverlay => kOverlay;

//   // ── Nav Aliases ────────────────────────────────────────────────────────
//   static Color get kNavPrimaryText => kTextPrimary;
//   static Color get kNavSelectedBackgroundStart => kNavSelectedStart;
//   static Color get kNavSelectedBackgroundEnd => kNavSelectedEnd;
// }

// class AppColors extends AppColor {
//   AppColors._() : super._();
//   static Color get textPrimary => AppColor.kTextPrimary;
//   static Color get textSecondary => AppColor.kTextSecondary;
// }
// ==================================
// end Option 2 Color
// ==================================

// =======================================
// Option 3
// =======================================
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:school_assgn/core/theme/theme_service.dart';

// class AppColor {
//   AppColor._();

//   // ── Branding ───────────────────────────────────────────────────────────
//   static const Color kGoogleBlue = Color(0xFF4285F4);
//   static const Color kGoogleRed = Color(0xFFEA4335);
//   static const Color kGoogleYellow = Color(0xFFFBBC05);
//   static const Color kGoogleGreen = Color(0xFF34A853);
//   static const Color kError = Color(0xFFEF4444);

//   // ── Accent (Ember Red) ─────────────────────────────────────────────────
//   static const Color kAccent = Color(0xFFE05252); // ember red
//   static const Color kAccentLight = Color(0xFFE87878); // lighter red
//   static const Color kAccentDark = Color(0xFFC03A3A); // deeper red
//   static const Color kLink = Color(0xFFE87878); // lighter for links

//   // ── Dark Palette (Ember Dark) ──────────────────────────────────────────
//   // Deep red-brown tones — bold, intense, premium
//   static const Color _darkBg = Color(0xFF130C0C); // deepest bg
//   static const Color _darkSurface = Color(0xFF1E1010); // cards, sheets
//   static const Color _darkCard = Color(0xFF251414); // elevated cards
//   static const Color _darkBorder = Color(0xFF2E1818); // subtle borders
//   static const Color _darkInput = Color(0xFF251414); // input fields
//   static const Color _darkDivider = Color(0xFF381C1C); // dividers

//   // ── Light Palette (warm creamy white) ─────────────────────────────────
//   static const Color _lightBg = Color(0xFFFAF5F5); // warm pinkish white
//   static const Color _lightSurface = Color(0xFFFFFFFF);
//   static const Color _lightCard = Color(0xFFFDF0F0);
//   static const Color _lightBorder = Color(0xFFEDD8D8);
//   static const Color _lightInput = Color(0xFFF7ECEC);

//   // ── Theme Getter ───────────────────────────────────────────────────────
//   static bool get _isDark => Get.find<ThemeService>().isDarkMode.value;

//   // ── Backgrounds ────────────────────────────────────────────────────────
//   static Color get kBackground => _isDark ? _darkBg : _lightBg;
//   static Color get kSurface => _isDark ? _darkSurface : _lightSurface;
//   static Color get kCard => _isDark ? _darkCard : _lightCard;
//   static Color get kBorder => _isDark ? _darkBorder : _lightBorder;
//   static Color get kDivider => _isDark ? _darkDivider : const Color(0xFFEDD8D8);

//   // ── Auth ───────────────────────────────────────────────────────────────
//   static Color get kAuthBackground => kBackground;
//   static Color get kAuthSurface => kSurface;
//   static Color get kAuthBorder => kBorder;
//   static Color get kAuthAccent => kAccent;

//   // ── Glassmorphism ──────────────────────────────────────────────────────
//   static Color get kOverlay => _isDark
//       ? const Color(0xFF130C0C).withOpacity(0.92)
//       : const Color(0xFFFAF5F5).withOpacity(0.92);

//   static Color get kGlassBorder => _isDark
//       ? const Color(0xFFFFFFFF).withOpacity(0.06)
//       : const Color(0xFF000000).withOpacity(0.06);

//   static Color get kShadow => _isDark
//       ? Colors.black.withOpacity(0.50)
//       : const Color(0xFFE05252).withOpacity(0.08);

//   // ── Text ───────────────────────────────────────────────────────────────
//   static Color get kTextPrimary => _isDark
//       ? const Color(0xFFF2E8E8) // warm soft white
//       : const Color(0xFF1A0A0A); // deep warm dark

//   static Color get kTextSecondary => _isDark
//       ? const Color(0xFFA07070) // muted warm rose
//       : const Color(0xFF8B5A5A); // warm mid rose-brown

//   static Color get kTextHint => _isDark
//       ? const Color(0xFF5A3535) // subtle dark hint
//       : const Color(0xFFBFA0A0);

//   // ── Inputs ─────────────────────────────────────────────────────────────
//   static Color get kInputBg => _isDark ? _darkInput : _lightInput;
//   static Color get kInputBorder =>
//       _isDark ? const Color(0xFF381C1C) : const Color(0xFFDDBBBB);
//   static Color get kInputFocused => kAccent;

//   // ── Cards ──────────────────────────────────────────────────────────────
//   static Color get kCardBg => _isDark ? _darkCard : _lightCard;
//   static Color get kCardBorder => _isDark ? _darkBorder : _lightBorder;

//   // ── Navigation ─────────────────────────────────────────────────────────
//   static Color get kNavIcon =>
//       _isDark ? const Color(0xFFA07070) : const Color(0xFF8B5A5A);

//   static Color get kNavBarBackground => _isDark
//       ? const Color(0xFF1E1010).withOpacity(0.94)
//       : const Color(0xFFFFFFFF).withOpacity(0.94);

//   static Color get kNavSelectedStart => kAccent;
//   static Color get kNavSelectedEnd => kAccentDark;

//   // ── Status ─────────────────────────────────────────────────────────────
//   static Color get kSuccess =>
//       _isDark ? const Color(0xFF5EC97A) : const Color(0xFF2E9E50);
//   static Color get kWarning =>
//       _isDark ? const Color(0xFFF0A050) : const Color(0xFFD08030);
//   static Color get kDanger =>
//       _isDark ? const Color(0xFFE05252) : const Color(0xFFC03A3A);

//   // ── Badge / Tag ────────────────────────────────────────────────────────
//   static Color get kBadgeBg =>
//       _isDark ? const Color(0xFF2E1818) : const Color(0xFFFDE8E8);
//   static Color get kBadgeText =>
//       _isDark ? const Color(0xFFE87878) : const Color(0xFFC03A3A);

//   // ── Misc / Legacy ──────────────────────────────────────────────────────
//   static Color get kOnAccent => Colors.white;
//   static Color get kPrimary => kAccent;
//   static Color get kSecondary => kTextSecondary;
//   static Color get kBgColor => kBackground;
//   static Color get kTextColor => kOnAccent;

//   // ── Auth Aliases ───────────────────────────────────────────────────────
//   static Color get kAuthTextPrimary => kTextPrimary;
//   static Color get kAuthTextSecondary => kTextSecondary;
//   static Color get kAuthLink => kLink;
//   static Color get kAuthBackgroundOverlay => kOverlay;

//   // ── Nav Aliases ────────────────────────────────────────────────────────
//   static Color get kNavPrimaryText => kTextPrimary;
//   static Color get kNavSelectedBackgroundStart => kNavSelectedStart;
//   static Color get kNavSelectedBackgroundEnd => kNavSelectedEnd;
// }

// class AppColors extends AppColor {
//   AppColors._() : super._();
//   static Color get textPrimary => AppColor.kTextPrimary;
//   static Color get textSecondary => AppColor.kTextSecondary;
// }

// ======================================
// end Option 3
// =====================================

// Option 4

// end Option 4
