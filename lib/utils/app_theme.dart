import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFFAEC6CF); // Pastel Blue
  static const Color primaryPink = Color(0xFFFFB7B2); // Pastel Pink
  static const Color primaryMint = Color(0xFFB5EAD7); // Pastel Mint
  static const Color primaryPurple = Color(0xFFC3B1E1); // Pastel Purple
  static const Color backgroundCream = Color(0xFFFDFD96); // Pastel Cream (very light)
  static const Color textDark = Color(0xFF4A4A4A);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFFFF9F0), // Soft cream/white
      primaryColor: primaryBlue,
      fontFamily: 'Pretendard', // Assuming usage or fallback to system
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        background: const Color(0xFFFFF9F0),
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: textDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
