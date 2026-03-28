import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_assgn/core/theme/theme_service.dart';

class AppColor {
  AppColor._();

  // ── Branding Colors ──────────────────────────────────────────
  static const Color kGoogleBlue   = Color(0xFF4285F4);
  static const Color kGoogleRed    = Color(0xFFEA4335);
  static const Color kGoogleYellow = Color(0xFFFBBC05);
  static const Color kGoogleGreen  = Color(0xFF34A853);
  static const Color kError        = Color(0xFFEF4444);
  
  static const Color kAccent       = Color(0xFF3B82F6); // Modern Blue
  static const Color kAccentLight  = Color(0xFF60A5FA);
  static const Color kAccentDark   = Color(0xFF2563EB);
  static const Color kLink         = Color(0xFF3B82F6);

  // ── Theme Re-active Getters ──────────────────────────────────
  static bool get _isDark => Get.find<ThemeService>().isDarkMode.value;

  // Backgrounds
  // Use slightly richer colors for premium feel
  static Color get kBackground => _isDark ? const Color(0xFF020617) : const Color(0xFFF1F5F9);
  static Color get kSurface    => _isDark ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF);
  static Color get kBorder     => _isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
  
  // High-level Auth Colors
  static Color get kAuthBackground => kBackground;
  static Color get kAuthSurface    => kSurface;
  static Color get kAuthBorder     => kBorder;
  static Color get kAuthAccent     => kAccent;
  
  // Overlays (Glassmorphism)
  // Ensure overlay is dense enough to provide contrast for text
  static Color get kOverlay    => _isDark ? const Color(0xE6020617) : const Color(0xF2FFFFFF);
  static Color get kGlassBorder => _isDark ? const Color(0x33FFFFFF) : const Color(0x33000000);
  static Color get kShadow      => _isDark ? Colors.black.withOpacity(0.5) : const Color(0x0F000000);
  
  // Text Colors (Using Zinc/Slate scales for premium feel)
  static Color get kTextPrimary   => _isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
  static Color get kTextSecondary => _isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  
  // Navigation
  static Color get kNavIcon             => _isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569);
  static Color get kNavBarBackground    => _isDark ? const Color(0xFF1E293B).withOpacity(0.8) : const Color(0xFFFDFDFD).withOpacity(0.8);
  static Color get kNavSelectedStart    => kAccent;
  static Color get kNavSelectedEnd      => kAccentDark;
  
  // Button Contrast Logic
  // Most primary buttons (Blue) should ALWAYS have white text for contrast
  static Color get kOnAccent => Colors.white;
  
  // Legacy aliases
  static Color get kPrimary      => kAccent;
  static Color get kSecondary    => kTextSecondary;
  static Color get kTextColor    => kOnAccent; // Used for text ON primary colors
  static Color get kBgColor      => kBackground;
  static Color get kAuthTextPrimary   => kTextPrimary;
  static Color get kAuthTextSecondary => kTextSecondary;
  static Color get kAuthLink          => kLink;
  static Color get kAuthBackgroundOverlay => kOverlay;
  static Color get kNavPrimaryText    => kTextPrimary;
  static Color get kNavSelectedBackgroundStart => kNavSelectedStart;
  static Color get kNavSelectedBackgroundEnd   => kNavSelectedEnd;
}

class AppColors extends AppColor {
  AppColors._() : super._();
  
  static Color get textPrimary   => AppColor.kTextPrimary;
  static Color get textSecondary => AppColor.kTextSecondary;
}


