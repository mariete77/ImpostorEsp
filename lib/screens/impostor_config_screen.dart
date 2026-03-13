import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/game_service.dart';
import 'role_reveal_screen.dart';

class ImpostorConfigScreen extends StatefulWidget {
  final GameService gameService;

  const ImpostorConfigScreen({
    super.key,
    required this.gameService,
  });

  @override
  State<ImpostorConfigScreen> createState() => _ImpostorConfigScreenState();
}

class _ImpostorConfigScreenState extends State<ImpostorConfigScreen> {
  late int _impostorCount;
  bool _isRevealing = false;
  String? _secretWord;
  String? _category;

  @override
  void initState() {
    super.initState();
    final game = widget.gameService.currentGame;
    _impostorCount = 1; // Default
    _secretWord = game?.secretWord;
    _category = game?.category;
  }

  int get _maxImpostors {
    final totalPlayers = widget.gameService.currentGame?.totalPlayers ?? 4;
    return (totalPlayers / 3).floor().clamp(1, totalPlayers - 1);
  }

  void _assignRolesAndStart() {
    final game = widget.gameService.currentGame;
    if (game == null) return;

    // Asignar roles con el número seleccionado
    widget.gameService.assignRolesAndWord();
    
    // Actualizar palabra y categoría
    setState(() {
      _secretWord = game.secretWord;
      _category = game.category;
    });

    // Iniciar revelación
    widget.gameService.startRevealing();
    
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RoleRevealScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPlayers = widget.gameService.currentGame?.totalPlayers ?? 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                'Configura la partida',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),

              // Información de jugadores
              _InfoCard(
                icon: Icons.people,
                title: 'Jugadores',
                value: '$totalPlayers jugadores',
                color: AppTheme.yellow,
              ),
              const SizedBox(height: 16),

              // Selector de número de impostores
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_off, color: AppTheme.red, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Número de impostores',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$_impostorCount',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Slider(
                        value: _impostorCount.toDouble(),
                        min: 1,
                        max: _maxImpostors.toDouble(),
                        divisions: _maxImpostors - 1,
                        onChanged: (value) {
                          setState(() {
                            _impostorCount = value.round();
                          });
                        },
                        activeColor: AppTheme.red,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getImpostorDescription(totalPlayers, _impostorCount),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Palabra secreta (oculta hasta asignar roles)
              _SecretWordCard(
                word: _secretWord ?? '???',
                category: _category ?? '???',
                isVisible: _isRevealing,
              ),
              const SizedBox(height: 32),

              // Botón principal
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow, size: 28),
                  label: Text(
                    _isRevealing ? 'Ver roles' : 'Asignar roles y continuar',
                    style: GoogleFonts.rubik(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: _assignRolesAndStart,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.yellow,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Instrucciones
              const _InstructionsCard(),
            ],
          ),
        ),
      ),
    );
  }

  String _getImpostorDescription(int total, int impostors) {
    if (impostors == 1) {
      return '1 impostor entre $total jugadores';
    }
    return '$impostors impostores entre $total jugadores (${(impostors / total * 100).toStringAsFixed(0)}%)';
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
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
  final bool isVisible;

  const _SecretWordCard({
    required this.word,
    required this.category,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.6,
      duration: const Duration(milliseconds: 500),
      child: Card(
        color: isVisible ? Colors.grey[100] : null,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.visibility, 
                            color: isVisible ? Colors.green : Colors.grey, 
                            size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Palabra secreta',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.yellow.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: isVisible
                    ? Text(
                        word,
                        key: const ValueKey('word_visible'),
                        style: GoogleFonts.rubik(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.red,
                          letterSpacing: 1.0,
                        ),
                      )
                    : Text(
                        '???',
                        key: const ValueKey('word_hidden'),
                        style: GoogleFonts.rubik(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                isVisible 
                    ? '¡Los ciudadanos verán esta palabra!'
                    : 'La palabra se revelará después de asignar roles',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InstructionsCard extends StatelessWidget {
  const _InstructionsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.yellow.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.yellow, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Cómo jugar',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildStep('1', 'Cada jugador, uno a uno, verá su rol en secreto'),
            _buildStep('2', 'Los ciudadanos verán la palabra secreta'),
            _buildStep('3', 'El impostor NO conoce la palabra (debe fingir)'),
            _buildStep('4', 'Durante la ronda, todos hablan y preguntan'),
            _buildStep('5', 'Al final, votad para eliminar al impostor'),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: AppTheme.red,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
