import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_assgn/themes/app_color.dart';

class ThemeService extends GetxService {
  Future<ThemeService> init() async {
    _updateTheme();
    return this;
  }

  void _updateTheme() {
    Get.changeThemeMode(ThemeMode.dark);
    _setSystemOverlayStyle();
  }

  void _setSystemOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF000000),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  ThemeData get currentTheme => darkTheme;

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColor.kAccent,
    scaffoldBackgroundColor: AppColor.kBackground,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.kAccent,
      brightness: Brightness.dark,
      surface: AppColor.kSurface,
      onSurface: AppColor.kTextPrimary,
      primary: AppColor.kAccent,
      secondary: AppColor.kAccentLight,
      error: AppColor.kError,
    ),
    cardTheme: CardThemeData(
      color: AppColor.kSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColor.kCardRadius),
        side: BorderSide(
          color: AppColor.kBorder,
          width: AppColor.kBorderWidth,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColor.kTextPrimary),
      titleTextStyle: TextStyle(
        color: AppColor.kTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColor.kAccent,
        foregroundColor: AppColor.kOnAccent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColor.kCardRadius),
        ),
      ),
    ),
  );
}
