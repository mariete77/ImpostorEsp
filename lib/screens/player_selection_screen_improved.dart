import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/game_service.dart';
import '../widgets/ui_components.dart';
import '../utils/design_constants.dart';
import 'impostor_config_screen.dart';

class PlayerSelectionScreen extends StatefulWidget {
  const PlayerSelectionScreen({super.key});

  @override
  State<PlayerSelectionScreen> createState() => _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState extends State<PlayerSelectionScreen>
    with SingleTickerProviderStateMixin {
  final GameService _gameService = GameService();
  int _playerCount = DesignConstants.defaultPlayers;
  final List<TextEditingController> _nameControllers = [];
  final List<FocusNode> _focusNodes = [];
  bool _canContinue = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeControllers(_playerCount);

    // Animación de entrada
    _animationController = AnimationController(
      duration: const Duration(milliseconds: DesignConstants.durationNormal),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _initializeControllers(int count) {
    // Limpiar controllers existentes
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _nameControllers.clear();
    _focusNodes.clear();

    // Crear nuevos controllers
    for (int i = 0; i < count; i++) {
      _nameControllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateForm();
    });
  }

  void _validateForm() {
    final allFilled = _nameControllers.every((c) => c.text.trim().isNotEmpty);
    final noDuplicates = _getUniqueNames().length == _nameControllers.length;

    setState(() {
      _canContinue = allFilled && noDuplicates;
    });
  }

  Set<String> _getUniqueNames() {
    return _nameControllers.map((c) => c.text.trim().toLowerCase()).toSet();
  }

  void _onPlayerCountChanged(int count) {
    setState(() {
      _playerCount = count;
    });
    _initializeControllers(count);
  }

  List<String> _getPlayerNames() {
    return _nameControllers.map((c) => c.text.trim()).toList();
  }

  void _continueToConfig() async {
    if (!_canContinue) return;

    try {
      // Calcular impostores basados en el número de jugadores (regla: 1 impostor por cada 3-4 jugadores)
      final impostorCount = (_playerCount / DesignConstants.maxImpostorsRatio).ceil().clamp(
        DesignConstants.minImpostors,
        (_playerCount / 3).floor(),
      );

      _gameService.createGame(
        playerNames: _getPlayerNames(),
        impostorCount: impostorCount,
        timePerPlayer: DesignConstants.timePerPlayer,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImpostorConfigScreen(
            gameService: _gameService,
            playerCount: _playerCount,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red.withOpacity(0.8),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Ajustes de Partida',
          style: GoogleFonts.spaceGrotesk(
            fontSize: DesignConstants.textLarge,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: DesignConstants.spacingLarge,
                ),
                child: Column(
                  children: [
                    SizedBox(height: DesignConstants.spacingLarge),

                    // Header
                    _buildHeader(),

                    SizedBox(height: DesignConstants.spacingLarge),

                    // Player Count Slider
                    _PlayerCountSlider(
                      playerCount: _playerCount,
                      onChanged: _onPlayerCountChanged,
                      minPlayers: DesignConstants.minPlayers,
                      maxPlayers: DesignConstants.maxPlayers,
                    ),

                    SizedBox(height: DesignConstants.spacingLarge),

                    // Player Names Grid
                    _PlayerNamesGrid(
                      controllers: _nameControllers,
                      focusNodes: _focusNodes,
                      playerCount: _playerCount,
                      onNameChanged: _validateForm,
                    ),

                    SizedBox(height: DesignConstants.spacingLarge),

                    // Continue Button
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: DesignConstants.spacingLarge + MediaQuery.of(context).padding.bottom,
                      ),
                      child: AnimatedButton(
                        label: 'CONTINUAR',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: _canContinue ? _continueToConfig : () {},
                        backgroundColor: AppTheme.primary,
                        height: DesignConstants.heightButton,
                        isLoading: false,
                      ),
                    ),

                    // Validation Error
                    if (!_canContinue && _nameControllers.any((c) => c.text.trim().isNotEmpty))
                      Padding(
                        padding: const EdgeInsets.only(bottom: DesignConstants.spacingMedium),
                        child: _buildValidationMessage(),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(DesignConstants.spacingMedium),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGradient,
        borderRadius: BorderRadius.circular(DesignConstants.radiusLarge),
        boxShadow: AppShadows.large(AppTheme.primary),
      ),
      child: Column(
        children: [
          Icon(
            Icons.group_rounded,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(height: DesignConstants.spacingSmall),
          Text(
            'Nombres de Jugadores',
            style: GoogleFonts.spaceGrotesk(
              fontSize: DesignConstants.textLarge,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: DesignConstants.spacingXSmall),
          Text(
            'Introduce un nombre para cada jugador',
            style: GoogleFonts.spaceGrotesk(
              fontSize: DesignConstants.textSmall,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationMessage() {
    final hasDuplicates = _getUniqueNames().length < _nameControllers.length;
    final hasEmpty = _nameControllers.any((c) => c.text.trim().isEmpty);

    if (hasDuplicates) {
      return Container(
        padding: const EdgeInsets.all(DesignConstants.spacingMedium),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(DesignConstants.radiusMedium),
          border: Border.all(
            color: Colors.red.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.withOpacity(0.7),
              size: 20,
            ),
            SizedBox(width: DesignConstants.spacingSmall),
            Expanded(
              child: Text(
                'Hay nombres duplicados. Por favor, usa nombres únicos.',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: DesignConstants.textSmall,
                  color: Colors.red.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (hasEmpty) {
      return Container(
        padding: const EdgeInsets.all(DesignConstants.spacingMedium),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(DesignConstants.radiusMedium),
          border: Border.all(
            color: Colors.orange.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Colors.orange.withOpacity(0.7),
              size: 20,
            ),
            SizedBox(width: DesignConstants.spacingSmall),
            Expanded(
              child: Text(
                'Faltan nombres por completar.',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: DesignConstants.textSmall,
                  color: Colors.orange.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// Widget para seleccionar número de jugadores con slider
class _PlayerCountSlider extends StatefulWidget {
  final int playerCount;
  final ValueChanged<int> onChanged;
  final int minPlayers;
  final int maxPlayers;

  const _PlayerCountSlider({
    required this.playerCount,
    required this.onChanged,
    required this.minPlayers,
    required this.maxPlayers,
  });

  @override
  State<_PlayerCountSlider> createState() => _PlayerCountSliderState();
}

class _PlayerCountSliderState extends State<_PlayerCountSlider> {
  late int _currentCount;

  @override
  void initState() {
    super.initState();
    _currentCount = widget.playerCount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignConstants.spacingMedium),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(DesignConstants.radiusLarge),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.people_rounded,
                    color: AppTheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: DesignConstants.spacingSmall),
                  Text(
                    'Número de Jugadores',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: DesignConstants.textMedium,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignConstants.spacingMedium,
                  vertical: DesignConstants.spacingSmall,
                ),
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryGradient,
                  borderRadius: BorderRadius.circular(DesignConstants.radiusMedium),
                ),
                child: Text(
                  '$_currentCount',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: DesignConstants.textXLarge,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: DesignConstants.spacingMedium),
          Slider(
            value: _currentCount.toDouble(),
            min: widget.minPlayers.toDouble(),
            max: widget.maxPlayers.toDouble(),
            divisions: widget.maxPlayers - widget.minPlayers,
            label: '$_currentCount jugadores',
            onChanged: (value) {
              setState(() {
                _currentCount = value.toInt();
              });
              widget.onChanged(_currentCount);
            },
            activeColor: AppTheme.primary,
            inactiveColor: Colors.white.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}

/// Grid de campos de nombre de jugadores
class _PlayerNamesGrid extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final int playerCount;
  final VoidCallback onNameChanged;

  const _PlayerNamesGrid({
    required this.controllers,
    required this.focusNodes,
    required this.playerCount,
    required this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: DesignConstants.spacingMedium,
        crossAxisSpacing: DesignConstants.spacingMedium,
        childAspectRatio: 1.0,
      ),
      itemCount: playerCount,
      itemBuilder: (context, index) {
        return _PlayerNameInput(
          controller: controllers[index],
          focusNode: focusNodes[index],
          playerNumber: index + 1,
          onChanged: onNameChanged,
        );
      },
    );
  }
}

/// Input individual de nombre de jugador
class _PlayerNameInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int playerNumber;
  final VoidCallback onChanged;

  const _PlayerNameInput({
    required this.controller,
    required this.focusNode,
    required this.playerNumber,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final name = controller.text.trim();
    final hasError = name.isEmpty;

    return Column(
      children: [
        // Avatar with initials
        Hero(
          tag: 'player_$playerNumber',
          child: Avatar(
            name: name.isNotEmpty ? name : 'Jugador $playerNumber',
            size: 48,
            isEliminated: false,
          ),
        ),
        const SizedBox(height: DesignConstants.spacingSmall),
        // Input
        StyledTextField(
          controller: controller,
          focusNode: focusNode,
          label: Formatting.getPlayerNumber(playerNumber),
          hint: 'Nombre del jugador',
          icon: Icons.person_outline,
          showError: hasError,
          errorText: hasError ? 'Nombre requerido' : null,
          onSubmitted: (_) {
            // Auto-focus al siguiente input
            final currentIndex = int.parse(focusNode.toString().split('#')[1]);
            final nextIndex = currentIndex + 1;
            // El focusNode debe ser pasado por el padre
          },
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}
