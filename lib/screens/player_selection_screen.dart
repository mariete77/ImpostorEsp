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
    // Limpiar existentes
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _nameControllers.clear();
    _focusNodes.clear();

    // Crear nuevos
    for (int i = 0; i < count; i++) {
      _nameControllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }

    // Actualizar validación
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
      // Crear juego en el servicio
      _gameService.createGame(
        playerNames: _getPlayerNames(),
        impostorCount: 1, // Se elegirá en la siguiente pantalla
        timePerPlayer: 15,
      );

      if (!mounted) return;
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImpostorConfigScreen(gameService: _gameService),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppTheme.red,
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
      appBar: AppBar(
        title: const Text('Jugadores'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector de número de jugadores
            _PlayerCountSelector(
              playerCount: _playerCount,
              onChanged: _onPlayerCountChanged,
            ),
            const SizedBox(height: 24),
            
            // Lista de campos de nombre
            Expanded(
              child: ListView.builder(
                itemCount: _playerCount,
                itemBuilder: (context, index) {
                  return _PlayerNameField(
                    index: index,
                    controller: _nameControllers[index],
                    focusNode: _focusNodes[index],
                    onChanged: (_) => _validateForm(),
                    onNext: () {
                      if (index < _focusNodes.length - 1) {
                        _focusNodes[index + 1].requestFocus();
                      } else {
                        // Último campo, intentar continuar
                        if (_canContinue) {
                          _continueToConfig();
                        }
                      }
                    },
                    onSubmitted: (_) => _onNext(index),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botón continuar
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _canContinue ? _continueToConfig : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Continuar',
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            // Mensaje de error si hay duplicados
            if (!_canContinue && _getUniqueNames().length != _nameControllers.length)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Los nombres deben ser únicos',
                  style: TextStyle(
                    color: AppTheme.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onNext(int index) {
    if (index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Número de jugadores',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: playerCount > 2 ? () => onChanged(playerCount - 1) : null,
                  tooltip: 'Menos jugadores',
                ),
                Text(
                  '$playerCount',
                  style: GoogleFonts.rubik(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.red,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: playerCount < 10 ? () => onChanged(playerCount + 1) : null,
                  tooltip: 'Más jugadores',
                ),
              ],
            ),
            Slider(
              value: playerCount.toDouble(),
              min: 2,
              max: 10,
              divisions: 8,
              onChanged: (value) => onChanged(value.round()),
              activeColor: AppTheme.red,
            ),
            const SizedBox(height: 8),
            Text(
              'Recomendado: 4-8 jugadores',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerNameField extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onNext;
  final ValueChanged<String> onSubmitted;

  const _PlayerNameField({
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onNext,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autocorrect: false,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: 'Jugador ${index + 1}',
          hintText: 'Nombre del jugador',
          prefixIcon: CircleAvatar(
            backgroundColor: AppTheme.red,
            foregroundColor: Colors.white,
            child: Text(
              '${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          errorText: controller.text.trim().isEmpty ? 'Campo requerido' : null,
        ),
        onChanged: onChanged,
        onSubmitted: (value) {
          onNext();
        },
        textInputAction: index < 9 ? TextInputAction.next : TextInputAction.done,
      ),
    );
  }
}
