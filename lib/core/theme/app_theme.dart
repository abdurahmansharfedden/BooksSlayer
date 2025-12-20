import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Pastel Colors
  static const Color pastelBlue = Color(0xFFB5EAEA);
  static const Color pastelPink = Color(0xFFFFBCBC);
  static const Color pastelYellow = Color(0xFFFBF7D5);
  static const Color pastelGreen = Color(0xFFC8E6C9);
  static const Color pastelPurple = Color(0xFFE1BEE7);

  // Core Colors
  static const Color primaryLight = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF8A84FF);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF1E1E1E);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF2C2C2C);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryLight,
        brightness: Brightness.light,
        surface: backgroundLight,
        primary: primaryLight,
        secondary: pastelPink,
        tertiary: pastelBlue,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: surfaceLight,
        shadowColor: Colors.black12,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDark,
        brightness: Brightness.dark,
        surface: backgroundDark,
        primary: primaryDark,
        secondary: pastelPink.withValues(alpha: 0.8),
        tertiary: pastelBlue.withValues(alpha: 0.8),
      ),
      scaffoldBackgroundColor: backgroundDark,
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: surfaceDark,
        shadowColor: Colors.black45,
      ),
    );
  }
}
