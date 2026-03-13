import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/game_service.dart';
import 'impostor_config_screen.dart';

class PlayerSelectionScreen extends StatefulWidget {
  const PlayerSelectionScreen({super.key});

  @override
  State<PlayerSelectionScreen> createState() => _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState extends State<PlayerSelectionScreen> {
  final GameService _gameService = GameService();
  
  int _playerCount = 4;
  final List<TextEditingController> _nameControllers = [];
  final List<FocusNode> _focusNodes = [];
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers(_playerCount);
  }

  void _initializeControllers(int count) {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _nameControllers.clear();
    _focusNodes.clear();

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
      final impostorCount = (_playerCount / 4).ceil().clamp(1, (_playerCount / 3).floor());
      
      _gameService.createGame(
        playerNames: _getPlayerNames(),
        impostorCount: impostorCount,
        timePerPlayer: 15,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppTheme.primary,
        ),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
        title: Text(
          'Ajustes de la Partida',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Title & Visual
              _buildHeader(),
              const SizedBox(height: 32),
              // Player Count Control
              _PlayerCountSelector(
                playerCount: _playerCount,
                onChanged: _onPlayerCountChanged,
              ),
              const SizedBox(height: 24),
              // Player Names
              Expanded(
                child: ListView.builder(
                  itemCount: _playerCount,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _PlayerNameField(
                        index: index,
                        controller: _nameControllers[index],
                        focusNode: _focusNodes[index],
                        onChanged: (_) => _validateForm(),
                        onSubmitted: (_) {
                          if (index < _focusNodes.length - 1) {
                            _focusNodes[index + 1].requestFocus();
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              // Error message
              if (!_canContinue && _getUniqueNames().length != _nameControllers.length)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Los nombres deben ser únicos',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.red[400],
                      fontSize: 14,
                    ),
                  ),
                ),
              // Continue Button
              _buildContinueButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.group_work,
            size: 40,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'El Impostor',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Ingresa los nombres de los jugadores',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _canContinue ? _continueToConfig : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppTheme.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continuar',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, size: 24),
          ],
        ),
      ),
    );
  }
}

class _PlayerCountSelector extends StatelessWidget {
  final int playerCount;
  final ValueChanged<int> onChanged;

  const _PlayerCountSelector({
    required this.playerCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.2),
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
                  const Icon(Icons.groups, color: AppTheme.primary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Número de Jugadores',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                '$playerCount',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Decrease button
              GestureDetector(
                onTap: playerCount > 4 ? () => onChanged(playerCount - 1) : null,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: playerCount > 4 
                        ? AppTheme.primary.withOpacity(0.2) 
                        : AppTheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.remove,
                    color: playerCount > 4 ? AppTheme.primary : AppTheme.primary.withOpacity(0.5),
                    size: 18,
                  ),
                ),
              ),
              // Slider
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                    activeTrackColor: AppTheme.primary,
                    inactiveTrackColor: Colors.grey[700],
                    thumbColor: Colors.white,
                    overlayColor: AppTheme.primary.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: playerCount.toDouble(),
                    min: 4,
                    max: 10,
                    divisions: 6,
                    onChanged: (value) => onChanged(value.round()),
                  ),
                ),
              ),
              // Increase button
              GestureDetector(
                onTap: playerCount < 10 ? () => onChanged(playerCount + 1) : null,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: playerCount < 10 
                        ? AppTheme.primary.withOpacity(0.2) 
                        : AppTheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: playerCount < 10 ? AppTheme.primary : AppTheme.primary.withOpacity(0.5),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '4',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              Text(
                '10',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerNameField extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const _PlayerNameField({
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: GoogleFonts.spaceGrotesk(color: Colors.white),
      autocorrect: false,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        hintText: 'Nombre del jugador ${index + 1}',
        hintStyle: GoogleFonts.spaceGrotesk(color: Colors.grey[500]),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        prefixIcon: Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: AppTheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: index < 19 ? TextInputAction.next : TextInputAction.done,
    );
  }
}
