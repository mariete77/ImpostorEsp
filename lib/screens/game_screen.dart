import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/game_service.dart';
import '../models/game.dart';
import 'voting_screen.dart';

class GameScreen extends StatefulWidget {
  final GameService gameService;

  const GameScreen({super.key, required this.gameService});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameService _gameService;
  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalTime = 0;
  bool _isTimeRunning = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _gameService = widget.gameService;
    _initializeGame();
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

  void _passTurnManually() {
    if (_isTimeRunning && !_isPaused) {
      _timer?.cancel();
      _onTimeUp();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final game = _gameService.currentGame!;
    final currentPlayer = game.getCurrentPlayer()!;
    final roundProgress = _totalTime > 0 ? (_totalTime - _remainingSeconds) / _totalTime : 0.0;
    final progress = 1.0 - roundProgress;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Top Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        _timer?.cancel();
                        Navigator.pop(context);
                      },
                      icon: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back, color: AppTheme.primary),
                      ),
                    ),
                    Text(
                      'El Impostor',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.settings, color: AppTheme.primary),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Tiempo de Debate',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Text(
                  'Fase de Discusión:',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '¡Encuentra al Impostor!',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Debatan quién es el impostor antes de que se acabe el tiempo.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Circular Timer
                _CircularTimer(
                  totalTime: _totalTime,
                  remaining: _remainingSeconds,
                  progress: progress,
                  formattedTime: _formatTime(_remainingSeconds),
                ),
                
                const SizedBox(height: 32),
                
                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _togglePause,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_isPaused ? Icons.play_circle : Icons.pause_circle, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          _isPaused ? 'Reanudar' : 'Pausar',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _finishTime,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary.withOpacity(0.1),
                      foregroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer_off, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Finalizar tiempo',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Player Status Bar
                _PlayerStatusBar(players: game.activePlayers),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularTimer extends StatelessWidget {
  final int totalTime;
  final int remaining;
  final double progress;
  final String formattedTime;

  const _CircularTimer({
    required this.totalTime,
    required this.remaining,
    required this.progress,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primary.withOpacity(0.1),
                width: 8,
              ),
            ),
          ),
          
          // Main Timer Container
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.backgroundDark,
              border: Border.all(
                color: AppTheme.primary.withOpacity(0.2),
                width: 12,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
          
          // Progress Ring (Custom Paint simulation)
          SizedBox(
            width: 220,
            height: 220,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
          
          // Center Content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formattedTime,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.hourglass_empty, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'RESTANTE',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[500],
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerStatusBar extends StatelessWidget {
  final List players;

  const _PlayerStatusBar({required this.players});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < players.length; i++)
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primary.withOpacity(0.3),
                  border: Border.all(
                    color: AppTheme.primary.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    'P${i + 1}',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${players.length} Jugadores sospechosos',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}

class _PlayerInfoCard extends StatelessWidget {
  final dynamic player;

  const _PlayerInfoCard({required this.player});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.red,
              radius: 30,
              child: Text(
                player.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: player.isImpostor
                          ? Colors.red.withOpacity(0.2)
                          : Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: player.isImpostor ? Colors.red : Colors.green,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      player.isImpostor ? 'IMPOSTOR' : 'CIUDADANO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: player.isImpostor ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecretWordCard extends StatelessWidget {
  final String word;
  final String category;

  const _SecretWordCard({
    required this.word,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.visibility, color: AppTheme.red, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'La palabra es:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.yellow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              word.toUpperCase(),
              style: GoogleFonts.rubik(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppTheme.red,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              '¡Todos los ciudadanos pueden verla!',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
