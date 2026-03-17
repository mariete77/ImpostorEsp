import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/game_service.dart';
import '../models/game.dart';
import '../widgets/ui_components.dart';
import '../utils/design_constants.dart';
import 'voting_screen.dart';

class GameScreen extends StatefulWidget {
  final GameService gameService;

  const GameScreen({super.key, required this.gameService});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {
  late GameService _gameService;
  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalTime = 0;
  bool _isTimeRunning = false;
  bool _isPaused = false;
  late AnimationController _timerController;
  late Animation<double> _timerAnimation;

  @override
  void initState() {
    super.initState();
    _gameService = widget.gameService;

    // Animación del temporizador
    _timerController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _timerAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_timerController);

    _initializeGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerController.dispose();
    super.dispose();
  }

  void _initializeGame() {
    final game = _gameService.currentGame;
    if (game == null) {
      Navigator.pop(context);
      return;
    }

    _gameService.startGameRound();

    final currentPlayer = game.getCurrentPlayer();
    if (currentPlayer != null) {
      setState(() {
        _totalTime = game.totalRoundTime;
        _remainingSeconds = game.timePerPlayer;
        _isTimeRunning = true;
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && mounted) {
        setState(() {
          _remainingSeconds--;
        });

        // Reiniciar animación cada segundo
        _timerController.reset();
        _timerController.forward();

        if (_remainingSeconds <= 0) {
          _timer?.cancel();
          _onTimeUp();
        }
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _finishTime() {
    _timer?.cancel();
    _onTimeUp();
  }

  void _onTimeUp() {
    _gameService.nextPlayerTurn();

    if (_gameService.currentGame!.phase == GamePhase.voting) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VotingScreen(gameService: _gameService),
          ),
        );
      }
    } else {
      final nextPlayer = _gameService.currentGame!.getCurrentPlayer();
      if (nextPlayer != null && mounted) {
        setState(() {
          _remainingSeconds = _gameService.currentGame!.timePerPlayer;
        });
        _startTimer();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = _gameService.currentGame;
    if (game == null) return const SizedBox.shrink();

    final currentPlayer = game.getCurrentPlayer();
    if (currentPlayer == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;
    final isWarning = _remainingSeconds <= DesignConstants.warningTime;
    final isCritical = _remainingSeconds <= 3;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: _buildAppBar(context, game),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: DesignConstants.spacingLarge,
          ),
          child: Column(
            children: [
              SizedBox(height: DesignConstants.spacingLarge),

              // Header con turno actual
              _buildTurnHeader(game, currentPlayer, isSmall),

              SizedBox(height: DesignConstants.spacingLarge),

              // Timer Circular
              _buildCircularTimer(game, isWarning, isCritical),

              SizedBox(height: DesignConstants.spacingLarge),

              // Palabra secreta
              _buildSecretWord(game),

              SizedBox(height: DesignConstants.spacingXLarge),

              // Botones de control
              _buildControlButtons(game),

              SizedBox(height: DesignConstants.spacingLarge),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Game game) {
    final currentPlayer = game.getCurrentPlayer();
    final playerIndex = game.players.indexOf(currentPlayer!) + 1;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          if (_isPaused) {
            _togglePause();
          }
          Navigator.pop(context);
        },
      ),
      title: Column(
        children: [
          Text(
            'Ronda de Juego',
            style: GoogleFonts.spaceGrotesk(
              fontSize: DesignConstants.textSmall,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Text(
            'Turno $playerIndex/${game.players.length}',
            style: GoogleFonts.spaceGrotesk(
              fontSize: DesignConstants.textMedium,
              fontWeight: FontWeight.w700,
              color: AppTheme.accentYellow,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        // Botón de pausa
        IconButton(
          icon: Icon(
            _isPaused ? Icons.play_arrow : Icons.pause,
            color: Colors.white,
          ),
          onPressed: _togglePause,
        ),
        const SizedBox(width: DesignConstants.spacingSmall),
        // Icono de estado del juego
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isWarning ? Colors.orange : AppTheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isWarning ? Colors.orange : AppTheme.primary).withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: DesignConstants.spacingMedium),
      ],
    );
  }

  Widget _buildTurnHeader(Game game, Player currentPlayer, bool isSmall) {
    return Container(
      padding: const EdgeInsets.all(DesignConstants.spacingMedium),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGradient,
        borderRadius: BorderRadius.circular(DesignConstants.radiusXLarge),
        boxShadow: AppShadows.large(AppTheme.primary),
      ),
      child: Row(
        children: [
          Hero(
            tag: 'player_${game.players.indexOf(currentPlayer)}',
            child: Avatar(
              name: currentPlayer.name,
              size: isSmall ? 48 : 56,
              isEliminated: currentPlayer.isEliminated,
            ),
          ),
          SizedBox(width: DesignConstants.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Turno de',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: DesignConstants.textSmall,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  currentPlayer.name,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isSmall ? DesignConstants.textXLarge : DesignConstants.textXXLarge,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularTimer(Game game, bool isWarning, bool isCritical) {
    final progress = _remainingSeconds / game.timePerPlayer;

    return AnimatedBuilder(
      animation: _timerAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_timerAnimation.value * 0.05),
          child: Container(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow effect
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: isCritical
                        ? [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ]
                        : isWarning
                            ? [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 3,
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: AppTheme.primary.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 3,
                                ),
                              ],
                  ),
                ),
                // Timer circular
                CircularProgressWithLabel(
                  progress: progress,
                  label: _remainingSeconds.toString(),
                  color: isCritical
                      ? Colors.red
                      : isWarning
                          ? Colors.orange
                          : AppTheme.primary,
                  size: 180,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSecretWord(Game game) {
    return Container(
      padding: const EdgeInsets.all(DesignConstants.spacingLarge),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(DesignConstants.radiusXLarge),
        border: Border.all(
          color: AppTheme.accentYellow.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentYellow.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: AppTheme.accentYellow,
            size: 32,
          ),
          SizedBox(height: DesignConstants.spacingSmall),
          Text(
            'Palabra Secreta',
            style: GoogleFonts.spaceGrotesk(
              fontSize: DesignConstants.textSmall,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: DesignConstants.spacingMedium),
          Text(
            game.secretWord,
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: DesignConstants.textXXLarge,
              fontWeight: FontWeight.w700,
              color: AppTheme.accentYellow,
              letterSpacing: 1,
              shadows: [
                Shadow(
                  color: AppTheme.accentYellow.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          SizedBox(height: DesignConstants.spacingSmall),
          Text(
            'Categoría: ${game.category}',
            style: GoogleFonts.spaceGrotesk(
              fontSize: DesignConstants.textSmall,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons(Game game) {
    return Row(
      children: [
        Expanded(
          child: AnimatedButton(
            label: 'SALTEAR TURNO',
            icon: Icons.skip_next_rounded,
            onPressed: _finishTime,
            backgroundColor: Colors.white.withOpacity(0.1),
            foregroundColor: Colors.white.withOpacity(0.9),
            height: DesignConstants.heightButtonSmall,
          ),
        ),
        SizedBox(width: DesignConstants.spacingMedium),
        Expanded(
          child: AnimatedButton(
            label: _isPaused ? 'RENAUDAR' : 'PAUSAR',
            icon: _isPaused ? Icons.play_arrow : Icons.pause,
            onPressed: _togglePause,
            backgroundColor: _isPaused ? Colors.green.withOpacity(0.2) : Colors.white.withOpacity(0.1),
            foregroundColor: Colors.white.withOpacity(0.9),
            height: DesignConstants.heightButtonSmall,
          ),
        ),
      ],
    );
  }
}
