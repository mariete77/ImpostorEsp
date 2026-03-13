import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/game_service.dart';
import 'role_reveal_screen.dart';

class ImpostorConfigScreen extends StatefulWidget {
  final GameService gameService;
  final int playerCount;

  const ImpostorConfigScreen({
    super.key,
    required this.gameService,
    required this.playerCount,
  });

  @override
  State<ImpostorConfigScreen> createState() => _ImpostorConfigScreenState();
}

class _ImpostorConfigScreenState extends State<ImpostorConfigScreen> {
  late int _impostorCount;
  String? _secretWord;
  String? _category;

  @override
  void initState() {
    super.initState();
    final game = widget.gameService.currentGame;
    // Calcular impostores recomendados
    _impostorCount = (widget.playerCount / 4).ceil().clamp(1, (widget.playerCount / 3).floor());
    if (_impostorCount < 1) _impostorCount = 1;
    _secretWord = game?.secretWord;
    _category = game?.category;
  }

  int get _maxImpostors {
    return (widget.playerCount / 3).floor().clamp(1, widget.playerCount - 1);
  }

  int get _minImpostors => 1;

  void _assignRolesAndStart() {
    final game = widget.gameService.currentGame;
    if (game == null) return;

    // Asignar roles y palabra pasando el número de impostores seleccionado
    widget.gameService.assignRolesAndWord(_impostorCount);
    
    setState(() {
      _secretWord = game.secretWord;
      _category = game.category;
    });

    widget.gameService.startRevealing();
    
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoleRevealScreen(gameService: widget.gameService),
        ),
      );
    }
  }

  void _resetToDefault() {
    setState(() {
      _impostorCount = (widget.playerCount / 4).ceil().clamp(1, (widget.playerCount / 3).floor());
      if (_impostorCount < 1) _impostorCount = 1;
    });
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
          onPressed: () => Navigator.pop(context),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Title & Visual
              _buildHeader(),
              const SizedBox(height: 32),
              // Players Control
              _buildInfoCard(
                icon: Icons.groups,
                title: 'Número de Jugadores',
                subtitle: '${widget.playerCount} jugadores',
              ),
              const SizedBox(height: 16),
              // Impostors Control
              _ImpostorCountSelector(
                impostorCount: _impostorCount,
                maxImpostors: _maxImpostors,
                minImpostors: _minImpostors,
                onChanged: (value) {
                  setState(() {
                    _impostorCount = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Info Card
              _buildInfoCard(
                icon: Icons.info_outline,
                title: 'Configuración recomendada',
                subtitle: 'Basada en ${widget.playerCount} jugadores, $_impostorCount impostor${_impostorCount > 1 ? 'es' : ''} es el balance ideal.',
                showReset: true,
                onReset: _resetToDefault,
              ),
              const SizedBox(height: 32),
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
          'Configura las reglas antes de comenzar',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    String? subtitle,
    bool showReset = false,
    VoidCallback? onReset,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showReset)
            GestureDetector(
              onTap: onReset,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Reset',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _assignRolesAndStart,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
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

class _ImpostorCountSelector extends StatelessWidget {
  final int impostorCount;
  final int maxImpostors;
  final int minImpostors;
  final ValueChanged<int> onChanged;

  const _ImpostorCountSelector({
    required this.impostorCount,
    required this.maxImpostors,
    required this.minImpostors,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final range = maxImpostors - minImpostors + 1;
    final progress = range > 1 ? (impostorCount - minImpostors) / (range - 1) : 0.0;

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
                  const Icon(Icons.person_search, color: AppTheme.primary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Número de Impostores',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                '$impostorCount',
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
                onTap: impostorCount > minImpostors 
                    ? () => onChanged(impostorCount - 1) 
                    : null,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: impostorCount > minImpostors 
                        ? AppTheme.primary.withOpacity(0.2) 
                        : AppTheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.remove,
                    color: impostorCount > minImpostors 
                        ? AppTheme.primary 
                        : AppTheme.primary.withOpacity(0.5),
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
                    value: impostorCount.toDouble(),
                    min: minImpostors.toDouble(),
                    max: maxImpostors.toDouble(),
                    divisions: range > 1 ? range - 1 : 1,
                    onChanged: (value) => onChanged(value.round()),
                  ),
                ),
              ),
              // Increase button
              GestureDetector(
                onTap: impostorCount < maxImpostors 
                    ? () => onChanged(impostorCount + 1) 
                    : null,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: impostorCount < maxImpostors 
                        ? AppTheme.primary.withOpacity(0.2) 
                        : AppTheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: impostorCount < maxImpostors 
                        ? AppTheme.primary 
                        : AppTheme.primary.withOpacity(0.5),
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
                '$minImpostors',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              Text(
                '$maxImpostors',
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
