import 'package:flutter/material.dart';

class AppColors {
  // === Seed Colors (untuk ThemeData) ===
  static const Color seedColorLight = Colors.blue;
  static const Color seedColorDark = Colors.blueAccent;

  // === Light Colors ===
  static const Color lightPrimary = seedColorLight;
  static const Color lightBackground = Colors.white;
  static const Color lightTextPrimary = Colors.black;
  static const Color lightTextSecondary = Colors.black54;

  // === Dark Colors ===
  static const Color darkPrimary = seedColorDark;
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Colors.white70;

  // === Dynamic Getters (tergantung ThemeMode) ===
  static Color primary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkPrimary
          : lightPrimary;

  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBackground
          : lightBackground;

  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkTextPrimary
          : lightTextPrimary;

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkTextSecondary
          : lightTextSecondary;
}
