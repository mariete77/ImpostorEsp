import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/game_service.dart';
import 'game_screen.dart';

class RoleRevealScreen extends StatefulWidget {
  const RoleRevealScreen({super.key});

  @override
  State<RoleRevealScreen> createState() => _RoleRevealScreenState();
}

class _RoleRevealScreenState extends State<RoleRevealScreen> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _flipAnimation;
  bool _isRevealed = false;
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _revealRole(BuildContext context) {
    if (_isRevealed) return;
    
    setState(() {
      _isRevealed = true;
    });
    _animationController.forward();
    
    // Pequeño delay antes de habilitar el botón
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _canContinue = true;
        });
      }
    });
  }

  void _continueToNext() {
    // Guardar el juego y avanzar
    final gameService = GameService(); // En producción, inyectar
    final hasMore = gameService.nextRevealPlayer();

    if (hasMore) {
      // Resetear para siguiente jugador
      setState(() {
        _isRevealed = false;
        _canContinue = false;
      });
      _animationController.reset();
    } else {
      // Terminado, ir al juego
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GameScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameService = GameService();
    final currentPlayer = gameService.currentGame?.getCurrentPlayer();

    if (currentPlayer == null) {
      return const Scaffold(
        body: Center(
          child: Text('Error: No hay jugador actual'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Revelación ${gameService.currentGame?.currentRound ?? 1}/${gameService.currentGame?.totalPlayers ?? 0}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance close button
                ],
              ),
            ),

            // Contenido principal
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar/número del jugador
                    _PlayerAvatar(playerName: currentPlayer.name),
                    const SizedBox(height: 40),

                    // Card de revelación
                    _RevealCard(
                      isRevealed: _isRevealed,
                      isImpostor: currentPlayer.isImpostor,
                      secretWord: gameService.currentGame?.secretWord ?? '',
                      animation: _flipAnimation,
                      onTap: () => _revealRole(context),
                    ),
                    const SizedBox(height: 40),

                    // Botón continuar
                    if (_canContinue)
                      _ContinueButton(onPressed: _continueToNext),
                    if (!_isRevealed)
                      const _TapToRevealText(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerAvatar extends StatelessWidget {
  final String playerName;

  const _PlayerAvatar({required this.playerName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppTheme.red,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              playerName[0].toUpperCase(),
              style: GoogleFonts.rubik(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          playerName,
          style: GoogleFonts.rubik(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const Text(
          '¿Eres el impostor?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _RevealCard extends StatelessWidget {
  final bool isRevealed;
  final bool isImpostor;
  final String secretWord;
  final Animation<double> animation;
  final VoidCallback onTap;

  const _RevealCard({
    required this.isRevealed,
    required this.isImpostor,
    required this.secretWord,
    required this.animation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(animation.value * 3.14159),
            child: Container(
              width: 280,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: isRevealed
                    ? _buildRevealedContent()
                    : _buildHiddenContent(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHiddenContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.visibility_off, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          'Toca para revelar',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRevealedContent() {
    if (isImpostor) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_off,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'ERES EL',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text(
            'IMPOSTOR',
            style: TextStyle(
              fontSize: 28,
              color: AppTheme.red,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '😈 Finge que sabes la palabra',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppTheme.yellow,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.visibility,
              size: 48,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Eres',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text(
            'CIUDADANO',
            style: TextStyle(
              fontSize: 22,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.red, width: 2),
            ),
            child: Text(
              secretWord.toUpperCase(),
              style: GoogleFonts.rubik(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.red,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '¡No se lo digas al impostor!',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }
  }
}

class _TapToRevealText extends StatelessWidget {
  const _TapToRevealText();

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 0.7,
      duration: const Duration(milliseconds: 1000),
      child: const Text(
        '¿Listo? Toca la tarjeta para ver tu rol',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ContinueButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_forward, size: 24),
      label: Text(
        'Siguiente jugador',
        style: GoogleFonts.rubik(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        backgroundColor: AppTheme.yellow,
        foregroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
      ),
    );
  }
}
