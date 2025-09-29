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
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: _seedLight,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    textTheme: TextTheme(
      titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.lightTextPrimary),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.lightTextSecondary),
      bodyMedium: AppTextStyles.body.copyWith(color: AppColors.lightTextPrimary),
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
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: _seedDark,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    textTheme: TextTheme(
      titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.darkTextPrimary),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.darkTextSecondary),
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
