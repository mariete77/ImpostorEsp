import 'package:flutter/material.dart';

/// Constantes de diseño para ImpostorEsp
class DesignConstants {
  // Espaciado
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  static const double radiusXXLarge = 24.0;

  // Alturas
  static const double heightInput = 56.0;
  static const double heightButton = 56.0;
  static const double heightButtonSmall = 40.0;

  // Duraciones de animación
  static const int durationFast = 150;
  static const int durationNormal = 300;
  static const int durationSlow = 600;

  // Tamaños de texto
  static const double textXSmall = 12.0;
  static const double textSmall = 14.0;
  static const double textMedium = 16.0;
  static const double textLarge = 18.0;
  static const double textXLarge = 24.0;
  static const double textXXLarge = 32.0;

  // Opacidades
  static const double opacityDisabled = 0.5;
  static const double opacityHint = 0.4;
  static const double opacitySecondary = 0.7;
  static const double opacityTertiary = 0.5;

  // Elevation
  static const double elevationNone = 0.0;
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;
  static const double elevationXLarge = 16.0;

  // Límites del juego
  static const int minPlayers = 2;
  static const int maxPlayers = 10;
  static const int defaultPlayers = 4;

  static const int minImpostors = 1;
  static const int maxImpostorsRatio = 3; // 1 impostor por cada 3 jugadores

  static const int timePerPlayer = 15; // segundos
  static const int warningTime = 5; // segundos para advertencia
}

/// Gradients personalizados
class AppGradients {
  static LinearGradient primaryGradient = const LinearGradient(
        colors: [
          Color(0xFF7311d4),
          Color(0xFF9D4EDD),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient secondaryGradient = const LinearGradient(
        colors: [
          Color(0xFFFACC15),
          Color(0xFFFFE55C),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient darkGradient = const LinearGradient(
        colors: [
          Color(0xFF191022),
          Color(0xFF1a1a2e),
          Color(0xFF16213e),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static LinearGradient cardGradient(Color color) => LinearGradient(
        colors: [
          color,
          color.withOpacity(0.7),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

/// Shadows personalizados
class AppShadows {
  static List<BoxShadow> small(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.15),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> medium(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> large(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> neon(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.4),
          blurRadius: 15,
          spreadRadius: 0,
        ),
      ];
}

/// Utilidades de formato
class Formatting {
  static String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String getPlayerNumber(int index) {
    return 'Jugador ${index + 1}';
  }
}
