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
        primaryContainer: AppColors.lightPrimaryContainer,
        // primaryContainer: AppColors.lightPrimary.withAlpha(20),
        // onPrimaryContainer: AppColors.lightPrimary,
        surfaceContainerLow:
            const Color.fromARGB(255, 255, 255, 255), // dipakai card
        surface: AppColors.lightBackground),
    disabledColor: Colors.grey.shade300,
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
    bottomNavigationBarTheme: BottomNavigationBarThemeData(),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color.fromARGB(255, 142, 192, 253),
      // backgroundColor: AppColors.lightPrimary,
      foregroundColor: Colors.black,
    ),

    textTheme: TextTheme(
        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: AppColors.lightTextSecondary,
        )),

    // TextTheme(
    //   titleLarge:
    //       AppTextStyles.titleLarge.copyWith(color: AppColors.lightTextPrimary),
    //   titleMedium: AppTextStyles.titleMedium
    //       .copyWith(color: AppColors.lightTextSecondary),
    //   bodyMedium:
    //       AppTextStyles.bodyMedium.copyWith(color: AppColors.lightTextPrimary),
    // ),
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
      primaryContainer: AppColors.darkPrimary.withAlpha(20),
      // onPrimaryContainer: AppColors.lightPrimary,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkPrimaryFabBackground,
      foregroundColor: AppColors.darkPrimaryFabForeground,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      surfaceTintColor: AppColors.darkBackground,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    textTheme: TextTheme(
      titleLarge: AppTextStyles.titleLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      titleMedium: AppTextStyles.titleMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      bodySmall: AppTextStyles.bodySmall.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      labelSmall: AppTextStyles.labelSmall.copyWith(
        color: AppColors.darkTextSecondary,
      ),
    ),

    // TextTheme(
    //   titleLarge:
    //       AppTextStyles.titleLarge.copyWith(color: AppColors.darkTextPrimary),
    //   titleMedium: AppTextStyles.titleMedium
    //       .copyWith(color: AppColors.darkTextSecondary),
    //   bodyMedium: AppTextStyles.body.copyWith(color: AppColors.darkTextPrimary),
    // ),
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
