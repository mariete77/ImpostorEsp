import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/game_service.dart';
import '../models/player.dart';
import '../models/game.dart';
import '../widgets/ui_components.dart';
import '../utils/design_constants.dart';
import 'home_screen.dart';

class VotingScreen extends StatefulWidget {
  final GameService gameService;

  const VotingScreen({super.key, required this.gameService});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen>
    with SingleTickerProviderStateMixin {
  late GameService _gameService;
  String? _selectedPlayerId;
  bool _hasVoted = false;
  bool _processing = false;
  String? _eliminatedPlayerName;
  bool _impostorEliminated = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _gameService = widget.gameService;

    // Animación de entrada
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: DesignConstants.durationNormal),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
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
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            gradient: AppGradients.darkGradient,
            borderRadius: BorderRadius.circular(DesignConstants.radiusXXLarge),
            border: Border.all(
              color: _impostorEliminated
                  ? Colors.green.withOpacity(0.3)
                  : Colors.red.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: (_impostorEliminated ? Colors.green : Colors.red).withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(DesignConstants.spacingLarge),
                decoration: BoxDecoration(
                  color: _impostorEliminated
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(DesignConstants.radiusXXLarge - 2),
                    topRight: Radius.circular(DesignConstants.radiusXXLarge - 2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: _impostorEliminated
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _impostorEliminated ? Icons.celebration_rounded : Icons.person_off_rounded,
                        size: 32,
                        color: _impostorEliminated ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(width: DesignConstants.spacingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _impostorEliminated ? '¡Impostor Eliminado!' : '¡Voto Fallido!',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: DesignConstants.textXLarge,
                              fontWeight: FontWeight.w700,
                              color: _impostorEliminated ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(height: DesignConstants.spacingXSmall),
                          Text(
                            _eliminatedPlayerName != null
                                ? 'Se eliminó a $_eliminatedPlayerName'
                                : 'Nadie fue eliminado',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: DesignConstants.textMedium,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Score table
              Container(
                padding: const EdgeInsets.all(DesignConstants.spacingLarge),
                child: Column(
                  children: [
                    Text(
                      'Puntuaciones',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: DesignConstants.textLarge,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: DesignConstants.spacingMedium),
                    ...game.players.map((player) {
                      final score = player.isImpostor ? player.score : 0;
                      final isEliminated = player.status == PlayerStatus.eliminated;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: DesignConstants.spacingSmall,
                          horizontal: DesignConstants.spacingMedium,
                        ),
                        decoration: BoxDecoration(
                          color: isEliminated
                              ? Colors.white.withOpacity(0.05)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(DesignConstants.radiusMedium),
                        ),
                        child: Row(
                          children: [
                            Hero(
                              tag: 'player_${game.players.indexOf(player)}',
                              child: Avatar(
                                name: player.name,
                                size: 40,
                                isEliminated: isEliminated,
                              ),
                            ),
                            const SizedBox(width: DesignConstants.spacingMedium),
                            Expanded(
                              child: Text(
                                player.name,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: DesignConstants.textMedium,
                                  fontWeight: FontWeight.w600,
                                  color: isEliminated
                                      ? Colors.white.withOpacity(0.5)
                                      : Colors.white,
                                ),
                              ),
                            ),
                            if (player.isImpostor) ...[
                              const SizedBox(width: DesignConstants.spacingSmall),
                              StatusChip(
                                label: 'IMPOSTOR',
                                color: Colors.red,
                                icon: Icons.person_off_rounded,
                              ),
                            ],
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: DesignConstants.spacingMedium,
                                vertical: DesignConstants.spacingSmall,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.accentYellow.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(DesignConstants.radiusSmall),
                              ),
                              child: Text(
                                '+$score pts',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: DesignConstants.textMedium,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.accentYellow,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              // Buttons
              Padding(
                padding: const EdgeInsets.all(DesignConstants.spacingLarge),
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedButton(
                        label: 'JUGAR OTRA VEZ',
                        icon: Icons.refresh_rounded,
                        onPressed: _playAgain,
                        backgroundColor: AppTheme.primary,
                        height: DesignConstants.heightButtonSmall,
                      ),
                    ),
                    const SizedBox(width: DesignConstants.spacingMedium),
                    Expanded(
                      child: AnimatedButton(
                        label: 'VOLVER AL MENÚ',
                        icon: Icons.home_rounded,
                        onPressed: _goHome,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        foregroundColor: Colors.white,
                        height: DesignConstants.heightButtonSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _playAgain() async {
    Navigator.pop(context);

    // Reiniciar el juego con los mismos jugadores
    _gameService.createGame(
      playerNames: _gameService.currentGame!.players.map((p) => p.name).toList(),
      impostorCount: _gameService.currentGame!.impostorCount,
      timePerPlayer: _gameService.currentGame!.timePerPlayer,
    );

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/impostor-config');
    }
  }

  void _goHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final game = _gameService.currentGame;
    if (game == null) return const SizedBox.shrink();

    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;

    final activePlayers = game!.players.where((p) => p.status != PlayerStatus.eliminated).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _goHome,
        ),
        title: Text(
          'Votación',
          style: GoogleFonts.spaceGrotesk(
            fontSize: DesignConstants.textLarge,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(DesignConstants.spacingLarge),
                child: Column(
                  children: [
                    // Header con instrucciones
                    _buildHeader(activePlayers.length),

                    SizedBox(height: DesignConstants.spacingLarge),

                    // Grid de jugadores para votar
                    Expanded(
                      child: _PlayersGrid(
                        players: activePlayers,
                        selectedPlayerId: _selectedPlayerId,
                        onPlayerSelected: (playerId) {
                          if (!_hasVoted) {
                            setState(() {
                              _selectedPlayerId = playerId;
                            });
                          }
                        },
                      ),
                    ),

                    // Botón de votar
                    if (!_hasVoted)
                      Padding(
                        padding: const EdgeInsets.all(DesignConstants.spacingLarge),
                        child: AnimatedButton(
                          label: 'VOTAR',
                          icon: Icons.how_to_vote_rounded,
                          onPressed: _selectedPlayerId != null ? _vote : () {},
                          backgroundColor: AppTheme.primary,
                          isLoading: _processing,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(int activePlayersCount) {
    return Container(
      padding: const EdgeInsets.all(DesignConstants.spacingMedium),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGradient,
        borderRadius: BorderRadius.circular(DesignConstants.radiusXLarge),
        boxShadow: AppShadows.large(AppTheme.primary),
      ),
      child: Row(
        children: [
          Icon(
            Icons.how_to_vote_rounded,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: DesignConstants.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vota por el impostor',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: DesignConstants.textMedium,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Selecciona a quién crees que es el impostor ($activePlayersCount jugadores activos)',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: DesignConstants.textSmall,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Grid de jugadores para votar
class _PlayersGrid extends StatelessWidget {
  final List<Player> players;
  final String? selectedPlayerId;
  final ValueChanged<String> onPlayerSelected;

  const _PlayersGrid({
    required this.players,
    required this.selectedPlayerId,
    required this.onPlayerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final crossAxisCount = size.width < 400 ? 2 : size.width < 600 ? 3 : 4;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: DesignConstants.spacingMedium,
        crossAxisSpacing: DesignConstants.spacingMedium,
        childAspectRatio: 1.0,
      ),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        final isSelected = selectedPlayerId == player.id;

        return _PlayerVotingCard(
          player: player,
          isSelected: isSelected,
          onTap: () => onPlayerSelected(player.id),
        );
      },
    );
  }
}

/// Tarjeta de jugador para votar
class _PlayerVotingCard extends StatefulWidget {
  final Player player;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlayerVotingCard({
    required this.player,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_PlayerVotingCard> createState() => _PlayerVotingCardState();
}

class _PlayerVotingCardState extends State<_PlayerVotingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: DesignConstants.durationFast),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isImpostor = widget.player.isImpostor;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isSelected ? _scaleAnimation.value : 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? AppTheme.primary.withOpacity(0.3)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(DesignConstants.radiusLarge),
                border: Border.all(
                  color: widget.isSelected
                      ? AppTheme.primary
                      : Colors.white.withOpacity(0.1),
                  width: widget.isSelected ? 2 : 1,
                ),
                boxShadow: widget.isSelected
                    ? AppShadows.neon(AppTheme.primary)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Avatar
                  Hero(
                    tag: 'player_${widget.player.name}',
                    child: Avatar(
                      name: widget.player.name,
                      size: 60,
                      isEliminated: false,
                    ),
                  ),
                  const SizedBox(height: DesignConstants.spacingSmall),
                  // Nombre
                  Text(
                    widget.player.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: DesignConstants.textMedium,
                      fontWeight: FontWeight.w600,
                      color: widget.isSelected ? AppTheme.primary : Colors.white,
                    ),
                  ),
                  // Indicador de seleccionado
                  if (widget.isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignConstants.spacingSmall,
                        vertical: DesignConstants.spacingXSmall,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(DesignConstants.radiusSmall),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
