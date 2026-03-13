import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colores de la bandera española
  static const Color red = Color(0xFFAA151B);     // Rojo bandera España
  static const Color yellow = Color(0xFFF1BF00);  // Amarillo bandera España
  static const Color darkRed = Color(0xFF8B0000);
  static const Color lightYellow = Color(0xFFFFE55C);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: red,
        onPrimary: Colors.white,
        secondary: yellow,
        onSecondary: Colors.black87,
        surface: Colors.white,
        onSurface: Colors.black87,
        background: Color(0xFFF5F5F5),
        onBackground: Colors.black87,
        error: Colors.red,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.rubikTextTheme().copyWith(
        displayLarge: GoogleFonts.rubik(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
        displayMedium: GoogleFonts.rubik(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
        displaySmall: GoogleFonts.rubik(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
        headlineLarge: GoogleFonts.rubik(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: red,
        ),
        headlineMedium: GoogleFonts.rubik(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: red,
        ),
        headlineSmall: GoogleFonts.rubik(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkRed,
        ),
        titleLarge: GoogleFonts.rubik(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        titleMedium: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        bodyLarge: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
        bodyMedium: GoogleFonts.rubik(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
        labelLarge: GoogleFonts.rubik(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: red,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: yellow,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: red,
          side: const BorderSide(color: red, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: red, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: red,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: red,
        onPrimary: Colors.white,
        secondary: yellow,
        onSecondary: Colors.black87,
        surface: Color(0xFF1E1E1E),
        onSurface: Colors.white,
        background: Color(0xFF121212),
        onBackground: Colors.white,
        error: Colors.red,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.rubikTextTheme().copyWith(
        displayLarge: GoogleFonts.rubik(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.rubik(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        displaySmall: GoogleFonts.rubik(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        headlineLarge: GoogleFonts.rubik(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: lightYellow,
        ),
        headlineMedium: GoogleFonts.rubik(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: lightYellow,
        ),
        headlineSmall: GoogleFonts.rubik(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: lightYellow,
        ),
        titleLarge: GoogleFonts.rubik(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
        ),
        bodyMedium: GoogleFonts.rubik(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
        ),
        labelLarge: GoogleFonts.rubik(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: red,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: yellow,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFF1E1E1E),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: red, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: red,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
