import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/game_service.dart';
import '../models/player.dart';
import 'home_screen.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  final GameService _gameService = GameService();
  String? _selectedPlayerId;
  bool _hasVoted = false;
  bool _processing = false;
  String? _eliminatedPlayerName;
  bool _impostorEliminated = false;

  @override
  void initState() {
    super.initState();
  }

  void _vote() async {
    if (_selectedPlayerId == null || _processing) return;

    setState(() {
      _processing = true;
    });

    await Future.delayed(const Duration(milliseconds: 500)); // Simular procesamiento

    // Contar votos (versión简化: solo el jugador actual vota)
    final votes = <String, int>{_selectedPlayerId!: 1};

    _gameService.processVoting(votes);

    final game = _gameService.currentGame!;
    final eliminatedPlayer = game.players
        .firstWhere((p) => p.status == PlayerStatus.eliminated, orElse: () => game.players.first);

    setState(() {
      _hasVoted = true;
      _processing = false;
      _eliminatedPlayerName = eliminatedPlayer.name;
      _impostorEliminated = eliminatedPlayer.isImpostor;
    });

    // Mostrar diálogo con resultado
    if (mounted) {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    final game = _gameService.currentGame!;
    final impostorWon = !_impostorEliminated;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Icon(
              _impostorEliminated ? Icons.check_circle : Icons.cancel,
              size: 48,
              color: _impostorEliminated ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 8),
            Text(
              _impostorEliminated ? '¡Impostor eliminado!' : '¡Voto fallido!',
              style: GoogleFonts.rubik(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _impostorEliminated ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _eliminatedPlayerName!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _impostorEliminated
                  ? '¡Bien hecho! El impostor ha sido descubierto.'
                  : 'El impostor logró escapar... ¡Sigue intentándolo!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            // Tabla de puntuaciones
            ...game.players.map((player) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              player.isImpostor
                                  ? Icons.person_off
                                  : Icons.person,
                              size: 16,
                              color: player.isImpostor ? Colors.red : Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                player.name,
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.yellow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${player.score}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetAndGoHome();
            },
            child: const Text('Volver al menú'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _playAgain();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.yellow,
            ),
            child: const Text('Jugar otra vez'),
          ),
        ],
      ),
    );
  }

  void _resetAndGoHome() {
    _gameService.resetGame();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  void _playAgain() {
    // Mantener jugadores pero reiniciar puntuaciones
    _gameService.resetGame();
    
    // Volver a la pantalla de revelación
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const VotingScreen(), // Esto debería ser la config screen
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = _gameService.currentGame!;
    final activePlayers = game.activePlayers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Votación'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF1a1a1a),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                '¿Quién es el impostor?',
                style: GoogleFonts.rubik(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selecciona al jugador que crees que es el impostor',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              // Grid de jugadores
              Expanded(
                child: _hasVoted
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Procesando votación...'),
                          ],
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: activePlayers.length,
                        itemBuilder: (context, index) {
                          final player = activePlayers[index];
                          final isSelected = _selectedPlayerId == player.id;
                          
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedPlayerId = player.id;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.red : Colors.grey[800],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppTheme.red : Colors.grey[600]!,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: isSelected
                                        ? Colors.white
                                        : Colors.grey[600],
                                    radius: 28,
                                    child: Text(
                                      player.name[0].toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? AppTheme.red
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    player.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[300],
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Botón votar
              if (!_hasVoted)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedPlayerId != null ? _vote : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'VOTAR',
                      style: GoogleFonts.rubik(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
