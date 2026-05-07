import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_assgn/themes/app_color.dart';

class ThemeService extends GetxService {
  final RxBool isDarkMode = true.obs;
  static const String _themeKey = 'isDarkMode';
  late SharedPreferences _prefs;

  Future<ThemeService> init() async {
    _prefs = await SharedPreferences.getInstance();
    isDarkMode.value = _prefs.getBool(_themeKey) ?? true;
    _updateTheme();
    return this;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _prefs.setBool(_themeKey, isDarkMode.value);
    // Tiny delay to let the switch UI animation finish smoothly before the heavy theme rebuild
    Future.delayed(const Duration(milliseconds: 50), () {
      _updateTheme();
    });
  }

  void _updateTheme() {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _setSystemOverlayStyle();
  }

  void _setSystemOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkMode.value
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: isDarkMode.value
            ? Brightness.dark
            : Brightness.light,
        systemNavigationBarColor: isDarkMode.value
            ? const Color(0xFF000000)
            : const Color(0xFFFFFFFF),
        systemNavigationBarIconBrightness: isDarkMode.value
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }

  ThemeData get currentTheme => isDarkMode.value ? darkTheme : lightTheme;

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColor.kAccent,
    scaffoldBackgroundColor:
        AppColor.kBackground, // Gets dark color dynamically
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
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColor.kAccent,
    scaffoldBackgroundColor:
        AppColor.kBackground, // Gets light color dynamically
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.kAccent,
      brightness: Brightness.light,
      surface: AppColor.kSurface,
      onSurface: AppColor.kTextPrimary,
      primary: AppColor.kAccent,
      secondary: AppColor.kAccentLight,
      error: AppColor.kError,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
  );
}
