import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/game_service.dart';
import '../models/player.dart';
import 'home_screen.dart';
import 'player_selection_screen.dart';
import 'impostor_config_screen.dart';

class VotingScreen extends StatefulWidget {
  final GameService gameService;

  const VotingScreen({super.key, required this.gameService});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  late GameService _gameService;
  String? _selectedPlayerId;
  bool _hasVoted = false;
  bool _processing = false;
  String? _eliminatedPlayerName;
  bool _impostorEliminated = false;

  @override
  void initState() {
    super.initState();
    _gameService = widget.gameService;
  }

  void _vote() async {
    if (_selectedPlayerId == null || _processing) return;

    setState(() {
      _processing = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

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

    if (mounted) {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    final game = _gameService.currentGame!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: AppTheme.backgroundDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _impostorEliminated 
                      ? Colors.green.withOpacity(0.2) 
                      : Colors.red.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _impostorEliminated ? Icons.check_circle : Icons.cancel,
                  size: 48,
                  color: _impostorEliminated ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              
              // Title
              Text(
                _impostorEliminated ? '¡Impostor eliminado!' : '¡Voto fallido!',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _impostorEliminated ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              
              // Eliminated player name
              Text(
                _eliminatedPlayerName!,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                _impostorEliminated
                    ? '¡Bien hecho! El impostor ha sido descubierto.'
                    : 'El impostor logró escapar... ¡Sigue intentándolo!',
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 24),
              
              // Divider
              Container(
                height: 1,
                color: Colors.white.withOpacity(0.1),
              ),
              const SizedBox(height: 16),
              
              // Score table
              Text(
                'Puntuaciones',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              
              ...game.players.map((player) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            player.isImpostor ? Icons.theater_comedy : Icons.person,
                            size: 18,
                            color: player.isImpostor ? Colors.red : AppTheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              player.name,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primary.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${player.score}',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              
              const SizedBox(height: 24),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _resetAndGoHome();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Volver al menú',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _playAgain();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Jugar otra vez',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
    // Mantener los mismos jugadores y sus puntuaciones
    _gameService.resetGameKeepScores();
    
    final playerCount = _gameService.currentGame!.players.length;
    
    // Ir directamente a la pantalla de configuración de impostores
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ImpostorConfigScreen(
          gameService: _gameService,
          playerCount: playerCount,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = _gameService.currentGame!;
    final activePlayers = game.activePlayers;

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
                      onPressed: () => Navigator.pop(context),
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
                    const SizedBox(width: 48),
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
                    'Votación',
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
                  '¿Quién es el',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Impostor?',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selecciona al jugador que crees que es el impostor',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Player Grid
                if (_hasVoted)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: AppTheme.primary),
                        const SizedBox(height: 16),
                        Text(
                          'Procesando votación...',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
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
                            color: isSelected 
                                ? AppTheme.primary.withOpacity(0.2) 
                                : Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected 
                                  ? AppTheme.primary 
                                  : Colors.white.withOpacity(0.1),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? AppTheme.primary 
                                      : Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    player.name[0].toUpperCase(),
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                player.name,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isSelected ? 'Seleccionado' : 'Toca para elegir',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 10,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                
                const SizedBox(height: 32),
                
                // Vote Button
                if (!_hasVoted)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedPlayerId != null ? _vote : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedPlayerId != null 
                            ? AppTheme.primary 
                            : Colors.grey[700],
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
                          const Icon(Icons.how_to_vote, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            'VOTAR',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
