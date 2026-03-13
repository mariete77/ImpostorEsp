import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/game_service.dart';
import 'voting_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameService _gameService;
  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalTime = 0;
  bool _isTimeRunning = false;

  @override
  void initState() {
    super.initState();
    _gameService = GameService();
    _initializeGame();
  }

  void _initializeGame() {
    final game = _gameService.currentGame;
    if (game == null) {
      Navigator.pop(context); // Volver al inicio si no hay juego
      return;
    }

    // Iniciar ronda de juego
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
      if (mounted) {
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

  void _onTimeUp() {
    // Pasar al siguiente jugador
    _gameService.nextPlayerTurn();
    
    if (_gameService.currentGame!.phase == GamePhase.voting) {
      // Ir a votación
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const VotingScreen(),
          ),
        );
      }
    } else {
      // Siguiente jugador
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
    if (_isTimeRunning) {
      _timer?.cancel();
      _onTimeUp();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = _gameService.currentGame!;
    final currentPlayer = game.getCurrentPlayer()!;
    final roundProgress = (_totalTime - _remainingSeconds) / _totalTime;

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: Text('Turno de ${currentPlayer.name}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _timer?.cancel();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Info del jugador actual
              _PlayerInfoCard(player: currentPlayer),
              const SizedBox(height: 32),

              // Palabra secreta (todos la ven)
              _SecretWordCard(
                word: game.secretWord,
                category: game.category,
              ),
              const SizedBox(height: 32),

              // Temporizador circular
              _CircularTimer(
                totalTime: _totalTime,
                remaining: _remainingSeconds,
                progress: roundProgress,
                onTimeUrgent: _remainingSeconds <= 5,
              ),
              const SizedBox(height: 24),

              // Texto informativo
              Text(
                'Tienes ${_remainingSeconds} segundos',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              if (_remainingSeconds <= 5)
                Text(
                  '¡Rápido!',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppTheme.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const Spacer(),

              // Botón pasar turno
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _passTurnManually,
                  icon: const Icon(Icons.skip_next),
                  label: const Text('Pasar turno'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Progreso de ronda
              LinearProgressIndicator(
                value: roundProgress,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.yellow),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 8),
              Text(
                'Jugador ${game.currentRound} de ${game.activePlayers.length}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerInfoCard extends StatelessWidget {
  final dynamic player; // Player type

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

class _CircularTimer extends StatelessWidget {
  final int totalTime;
  final int remaining;
  final double progress;
  final bool onTimeUrgent;

  const _CircularTimer({
    required this.totalTime,
    required this.remaining,
    required this.progress,
    required this.onTimeUrgent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Fondo
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
          ),
          // Progreso
          SizedBox(
            width: 160,
            height: 160,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                onTimeUrgent ? Colors.red : AppTheme.yellow,
              ),
            ),
          ),
          // Texto central
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$remaining',
                style: GoogleFonts.rubik(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Text(
                'segundos',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
