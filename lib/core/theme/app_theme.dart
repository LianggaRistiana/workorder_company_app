import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // pakai seed color dari AppColors
  static final Color _seedLight = AppColors.seedColorLight;
  static final Color _seedDark = AppColors.seedColorDark;

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedLight,
      brightness: Brightness.light,
    ).copyWith(
        primary: AppColors.lightPrimary,
        surfaceContainerLow:
            const Color.fromARGB(255, 255, 255, 255), // dipakai card
        surface: AppColors.lightBackground),
    // colorScheme: const ColorScheme.light(
    //   primary: Color(0xFF3F51B5), // warna utama
    //   onPrimary: Colors.white,
    //   surface: Color(0xFFF8F9FB), // 🎯 warna permukaan (card, sheet, dialog)
    //   onSurface: Color(0xFF1A1C1E),
    //   secondary: Color(0xFF7986CB),
    //   onSecondary: Colors.white,
    // ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      surfaceTintColor: AppColors.lightBackground,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    // bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //   backgroundColor: Colors.black
    // ),
    textTheme: TextTheme(
      titleLarge:
          AppTextStyles.titleLarge.copyWith(color: AppColors.lightTextPrimary),
      titleMedium: AppTextStyles.titleMedium
          .copyWith(color: AppColors.lightTextSecondary),
      bodyMedium:
          AppTextStyles.body.copyWith(color: AppColors.lightTextPrimary),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _seedLight,
        foregroundColor: Colors.white,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedDark,
      brightness: Brightness.dark,
    ).copyWith(
      // primary: AppColors.darkPrimary
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      surfaceTintColor: AppColors.darkBackground,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    textTheme: TextTheme(
      titleLarge:
          AppTextStyles.titleLarge.copyWith(color: AppColors.darkTextPrimary),
      titleMedium: AppTextStyles.titleMedium
          .copyWith(color: AppColors.darkTextSecondary),
      bodyMedium: AppTextStyles.body.copyWith(color: AppColors.darkTextPrimary),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _seedDark,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
