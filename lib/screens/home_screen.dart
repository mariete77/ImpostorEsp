import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../utils/design_constants.dart';
import '../services/audio_service.dart';
import 'player_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _neonController;
  late Animation<double> _neonAnimation;
  late AudioService _audioService;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    
    _neonController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _neonAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _neonController,
        curve: Curves.easeInOut,
      ),
    );
    _neonController.repeat(reverse: true);
    
    // Iniciar música de fondo después de que el widget está montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _audioService.playBackgroundMusic();
    });
  }

  @override
  void dispose() {
    _neonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          // Fondo con huella dactilar animada
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _neonAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.backgroundDark,
                        AppTheme.backgroundDark.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Opacity(
                      opacity: _neonAnimation.value * 0.15,
                      child: Icon(
                        Icons.fingerprint,
                        size: 350,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Contenido principal
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Icon con efecto de neón pulsante
                    AnimatedBuilder(
                      animation: _neonAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primary,
                                AppTheme.primary.withValues(alpha: 0.6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: AppShadows.neon(
                              AppTheme.primary.withValues(alpha: _neonAnimation.value),
                            ),
                          ),
                          child: const Icon(
                            Icons.fingerprint,
                            size: 64,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'El Impostor',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Descubre al traidor',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        color: Colors.grey[400],
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Main Play Button
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: () {
                          // Detener música al comenzar el juego
                          _audioService.stopMusic();
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          shadowColor: AppTheme.primary.withOpacity(0.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.play_arrow, size: 32),
                            const SizedBox(width: 12),
                            Text(
                              'JUGAR AHORA',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Secondary Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _SecondaryButton(
                            icon: Icons.menu_book,
                            label: 'Cómo Jugar',
                            onPressed: () => _showRulesModal(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _SecondaryButton(
                            icon: Icons.history,
                            label: 'Historial',
                            onPressed: () {
                              // TODO: Implement history screen
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Próximamente'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    // Footer
                    Text(
                      'Versión 2.0',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Botón de música flotante
          Positioned(
            top: 16,
            right: 16,
            child: _MusicToggleButton(
              audioService: _audioService,
            ),
          ),
        ],
      ),
    );
  }
}

class _MusicToggleButton extends StatelessWidget {
  final AudioService audioService;

  const _MusicToggleButton({
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: audioService,
      builder: (context, child) {
        return FloatingActionButton(
          heroTag: 'music_button',
          mini: true,
          onPressed: () {
            audioService.toggleMusic();
          },
          backgroundColor: audioService.isMusicEnabled
              ? AppTheme.primary.withOpacity(0.9)
              : Colors.grey.withOpacity(0.6),
          child: Icon(
            audioService.isMusicEnabled ? Icons.music_note : Icons.music_off,
            color: Colors.white,
          ),
        );
      },
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

// Modal de reglas del juego
void _showRulesModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const _RulesModal(),
  );
}

class _RulesModal extends StatelessWidget {
  const _RulesModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 500),
        decoration: BoxDecoration(
          color: AppTheme.backgroundDark,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary.withOpacity(0.2),
                    Colors.transparent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.rule,
                    color: AppTheme.accentYellow,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Cómo Jugar',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content - Scrollable
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      'Objetivo',
                      'Descubre al impostor entre los jugadores antes de que termine la ronda. Los ciudadanos deben eliminar al impostor, y el impostor debe escapar sin ser descubierto.',
                      Icons.flag,
                    ),
                    _buildSection(
                      'Configuración',
                      '1. Elige cuántos jugadores participan (2-10)\n'
                      '2. Selecciona cuántos impostores habrá (máximo 1 por cada 3 jugadores)\n'
                      '3. Se asigna una palabra secreta a todos los jugadores',
                      Icons.settings,
                    ),
                    _buildSection(
                      'Revelación de Roles',
                      'Cada jugador, uno por uno, ve su pantalla y toca para revelar su rol:\n'
                      '• **CIUDADANO**: Verás la palabra secreta\n'
                      '• **IMPOSTOR**: Verás "ERES EL IMPOSTOR" (no sabes la palabra)',
                      Icons.visibility,
                    ),
                    _buildSection(
                      'Ronda de Juego',
                      'Todos los jugadores ven la palabra secreta durante su turno.\n\n'
                      '⏱️ Tienes 15 segundos por jugador. Pasa tu turno manualmente o espera a que termine el tiempo.\n\n'
                      'Cuando todos hayan jugado, pasáis a la fase de votación.',
                      Icons.timer,
                    ),
                    _buildSection(
                      'Votación',
                      '1. Cada jugador vota por quién cree que es el impostor\n'
                      '2. Se cuenta el jugador con más votos\n'
                      '3. Si hay empate o nadie vota, nadie es eliminado\n'
                      '4. Si hay un ganador claro, ese jugador es eliminado',
                      Icons.how_to_vote,
                    ),
                    _buildSection(
                      'Resultados',
                      '• Si el impostor fue eliminado → **GANAN LOS CIUDADANOS**\n'
                      '• Si el impostor escapó → **GANA EL IMPOSTOR**\n\n'
                      'El impostor recibe 1 punto por cada vez que escapa. Los ciudadanos no acumulan puntos en esta versión.',
                      Icons.emoji_events,
                    ),
                    _buildSection(
                      'Reiniciar',
                      'Al terminar, puedes:\n'
                      '• **Jugar otra vez**: Mantiene los mismos jugadores y sus puntuaciones\n'
                      '• **Volver al menú**: Regresa a la pantalla principal',
                      Icons.refresh,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Text(
                '¡Disfruta del juego! 🎮',
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.accentYellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.accentYellow,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentYellow,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 42),
          child: Text(
            content,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              height: 1.5,
              color: Colors.grey[300],
            ),
          ),
        ),
      ],
    );
  }
}