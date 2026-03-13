import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    const ImpostorEspApp(),
  );
}

class ImpostorEspApp extends StatelessWidget {
  const ImpostorEspApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ImpostorEsp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}

// Configuración de rutas
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    // Rutas pendientes de implementación:
    // GoRoute(path: '/players', builder: (context, state) => PlayerSelectionScreen()),
    // GoRoute(path: '/config', builder: (context, state) => ImpostorConfigScreen()),
    // GoRoute(path: '/reveal', builder: (context, state) => RoleRevealScreen()),
    // GoRoute(path: '/game', builder: (context, state) => GameScreen()),
    // GoRoute(path: '/voting', builder: (context, state) => VotingScreen()),
    // GoRoute(path: '/stats', builder: (context, state) => StatsScreen()),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Página no encontrada',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Volver al inicio'),
          ),
        ],
      ),
    ),
  ),
);
