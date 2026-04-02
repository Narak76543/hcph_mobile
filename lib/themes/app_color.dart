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

  static const Color kAccent = Color(0xFF3B82F6); // Modern Blue
  static const Color kAccentLight = Color(0xFF60A5FA);
  static const Color kAccentDark = Color(0xFF2563EB);
  static const Color kLink = Color(0xFF3B82F6);

  // ── Theme Re-active Getters ──────────────────────────────────
  static bool get _isDark => Get.find<ThemeService>().isDarkMode.value;

  // Backgrounds
  // Use slightly richer colors for premium feel (Tailwind Slate/Zinc scale)
  static Color get kBackground =>
      _isDark ? const Color(0xFF000000) : const Color(0xFFF1F5F9);
  static Color get kSurface =>
      _isDark ? const Color(0xFF101010) : const Color(0xFFFFFFFF);
  static Color get kBorder =>
      _isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE2E8F0);

  // High-level Auth Colors
  static Color get kAuthBackground => kBackground;
  static Color get kAuthSurface => kSurface;
  static Color get kAuthBorder => kBorder;
  static Color get kAuthAccent => kAccent;

  // Overlays (Glassmorphism)
  // Ensure overlay is dense enough to provide contrast for text
  static Color get kOverlay =>
      _isDark ? const Color(0xE6000000) : const Color(0xF2FFFFFF);
  static Color get kGlassBorder =>
      _isDark ? const Color(0x33FFFFFF) : const Color(0x33000000);
  static Color get kShadow =>
      _isDark ? Colors.black.withValues(alpha: 0.5) : const Color(0x0F000000);

  // Text Colors (Using Zinc/Slate scales for premium feel)
  static Color get kTextPrimary =>
      _isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A);
  static Color get kTextSecondary =>
      _isDark ? const Color(0xFFAAAAAA) : const Color(0xFF64748B);

  // Navigation
  static Color get kNavIcon =>
      _isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569);
  static Color get kNavBarBackground => _isDark
      ? const Color(0xFF1A1A1A).withValues(alpha: 0.8)
      : const Color(0xFFFDFDFD).withValues(alpha: 0.8);
  static Color get kNavSelectedStart => kAccent;
  static Color get kNavSelectedEnd => kAccentDark;

  // Button Contrast Logic
  // Most primary buttons (Blue) should ALWAYS have white text for contrast
  static Color get kOnAccent => Colors.white;

  // Legacy aliases
  static Color get kPrimary => kAccent;
  static Color get kSecondary => kTextSecondary;
  static Color get kTextColor => kOnAccent; // Used for text ON primary colors
  static Color get kBgColor => kBackground;
  static Color get kAuthTextPrimary => kTextPrimary;
  static Color get kAuthTextSecondary => kTextSecondary;
  static Color get kAuthLink => kLink;
  static Color get kAuthBackgroundOverlay => kOverlay;
  static Color get kNavPrimaryText => kTextPrimary;
  static Color get kNavSelectedBackgroundStart => kNavSelectedStart;
  static Color get kNavSelectedBackgroundEnd => kNavSelectedEnd;
}

class AppColors extends AppColor {
  AppColors._() : super._();

  static Color get textPrimary => AppColor.kTextPrimary;
  static Color get textSecondary => AppColor.kTextSecondary;
}

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
