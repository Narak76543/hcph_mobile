import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_assgn/themes/app_color.dart';

class ThemeService extends GetxService {
  final _prefsKey = 'isDarkMode';
  final RxBool isDarkMode = false.obs;

  Future<ThemeService> init() async {
    final prefs = await SharedPreferences.getInstance();
    // Use system brightness if no preference exists
    if (!prefs.containsKey(_prefsKey)) {
      isDarkMode.value = Get.isPlatformDarkMode;
    } else {
      isDarkMode.value = prefs.getBool(_prefsKey) ?? false;
    }
    _updateTheme();
    return this;
  }

  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, isDarkMode.value);
    _updateTheme();
  }

  void _updateTheme() {
    final mode = isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(mode);

    // Update system overlay style
    _setSystemOverlayStyle(isDarkMode.value);
  }

  void _setSystemOverlayStyle(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC),
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
    );
  }

  ThemeData get currentTheme => isDarkMode.value ? darkTheme : lightTheme;

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColor.kAccent,
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.kAccent,
      brightness: Brightness.light,
      surface: Colors.white,
      onSurface: const Color(0xFF0F172A),
      primary: AppColor.kAccent,
      secondary: AppColor.kAccentDark,
      error: AppColor.kError,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFF0F172A)),
      titleTextStyle: TextStyle(
        color: Color(0xFF0F172A),
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColor.kAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColor.kAccent,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.kAccent,
      brightness: Brightness.dark,
      surface: const Color(0xFF1E293B),
      onSurface: const Color(0xFFF8FAFC),
      primary: AppColor.kAccent,
      secondary: AppColor.kAccentLight,
      error: AppColor.kError,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E293B),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF334155), width: 1),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFFF8FAFC)),
      titleTextStyle: TextStyle(
        color: Color(0xFFF8FAFC),
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColor.kAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

}
