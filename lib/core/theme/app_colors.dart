import 'package:flutter/material.dart';

class AppColors {
  // === Seed Colors (untuk ThemeData) ===
  static const Color seedColorLight = Colors.blue;
  static const Color seedColorDark = Colors.blueAccent;

  // === Light Colors ===
  // static const Color lightPrimary = Color.fromARGB(255, 0, 126, 230);
  static const Color lightPrimary = Color(0xFF0978FE);
  static const Color lightPrimaryContainer = Color(0xFFEBF4FF);
  // static const Color lightBackground = Color.fromARGB(255, 243, 243, 245);
  static const Color lightBackground = Color.fromARGB(255, 255, 255, 255);

  // === Dark Colors ===
  static const Color darkPrimary = seedColorDark;
  static const Color darkPrimaryFabForeground = Color.fromARGB(255, 190, 209, 249);
  static const Color darkPrimaryFabBackground = Color(0xFF304579);
  static const Color darkBackground = Color(0xFF121212);

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

  // 🌞 Light Mode
  static const Color lightTextPrimary = Color(0xFF212121);   // hampir hitam
  static const Color lightTextSecondary = Color(0xFF5F6368); // abu-abu sedang
  static const Color lightTextDisabled = Color(0xFF9E9E9E);  // abu muda

  // 🌚 Dark Mode
  static const Color darkTextPrimary = Color(0xFFEDEDED);    // hampir putih
  static const Color darkTextSecondary = Color(0xFFB0B0B0);  // abu muda
  static const Color darkTextDisabled = Color(0xFF6F6F6F);   // abu gelap
}
