import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colores del diseño - Tema púrpura/amarillo
  static const Color primary = Color(0xFF7311d4);     // Púrpura principal
  static const Color accentYellow = Color(0xFFfacc15); // Amarillo accent
  static const Color backgroundLight = Color(0xFFf7f6f8);
  static const Color backgroundDark = Color(0xFF191022);
  
  // Colores originales (por si acaso)
  static const Color red = Color(0xFFAA151B);
  static const Color yellow = Color(0xFFF1BF00);
  static const Color darkRed = Color(0xFF8B0000);
  static const Color lightYellow = Color(0xFFFFE55C);

  // Efectos de neón
  static List<BoxShadow> get neonGlow => [
    BoxShadow(
      color: primary.withOpacity(0.4),
      blurRadius: 15,
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> get accentGlow => [
    BoxShadow(
      color: accentYellow.withOpacity(0.3),
      blurRadius: 15,
      spreadRadius: 0,
    ),
  ];

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
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: Colors.white,
        secondary: accentYellow,
        onSecondary: Colors.black87,
        surface: backgroundDark,
        onSurface: Colors.white,
        error: Colors.red,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundDark,
      textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 57,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -1,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: accentYellow,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: accentYellow,
        ),
        headlineSmall: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: accentYellow,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.spaceGrotesk(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.spaceGrotesk(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
        ),
        bodyMedium: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
        ),
        labelLarge: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accentYellow,
          foregroundColor: Colors.black87,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white.withOpacity(0.05),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
