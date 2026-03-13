import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'player_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Header with user info
                  _buildHeader(),
                  const SizedBox(height: 40),
                  // Logo Section
                  _buildLogo(),
                  const SizedBox(height: 40),
                  // Main Action Buttons
                  _buildMainActions(),
                  const SizedBox(height: 32),
                  // Secondary Actions
                  _buildSecondaryActions(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.person,
                color: AppTheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jugador',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Explorador_ES',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.settings,
            color: Colors.grey[400],
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        children: [
          // Logo Container
          Stack(
            alignment: Alignment.center,
            children: [
              // Gradient blur behind
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.primary.withOpacity(0.3),
                      AppTheme.primary.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Main logo container
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: AppTheme.primary.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fingerprint,
                      size: 100,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      Icons.castle,
                      size: 32,
                      color: AppTheme.accentYellow,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Title
          Text(
            'EL ',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          Text(
            'IMPOSTOR',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          // Edition badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.accentYellow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'EDICIÓN ESPAÑA',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainActions() {
    return Column(
      children: [
        // Main Play Button with pulse animation
        ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlayerSelectionScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_circle, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    'PARTIDA RÁPIDA',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryActions() {
    return Row(
      children: [
        // How to Play Button
        Expanded(
          child: _SecondaryButton(
            icon: Icons.menu_book,
            label: 'Cómo jugar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cómo jugar - Próximamente'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        // Achievements Button
        Expanded(
          child: _SecondaryButton(
            icon: Icons.military_tech,
            label: 'Logros',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logros - Próximamente'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: icon == Icons.menu_book 
                    ? AppTheme.accentYellow 
                    : AppTheme.primary,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
