import '../models/game.dart';
import '../models/player.dart';
import 'word_service.dart';
import 'dart:math';

class GameService {
  Game? _currentGame;
  final Random _random = Random();

  Game? get currentGame => _currentGame;
  bool get isGameInProgress => _currentGame != null && 
      _currentGame!.phase != GamePhase.setup && 
      _currentGame!.phase != GamePhase.ended;

  /// Crea un nuevo juego con los jugadores especificados
  Game createGame({
    required List<String> playerNames,
    required int impostorCount,
    int timePerPlayer = 15,
  }) {
    // Validar
    if (playerNames.length < 2) {
      throw ArgumentError('Mínimo 2 jugadores');
    }
    if (impostorCount < 1 || impostorCount > (playerNames.length ~/ 3)) {
      throw ArgumentError('Número de impostores no válido');
    }

    // Crear jugadores
    final players = playerNames
        .map((name) => Player(
              id: _generateId(),
              name: name,
              role: PlayerRole.citizen, // Se asignará después
              status: PlayerStatus.waiting,
            ))
        .toList();

    // Crear juego
    _currentGame = Game(
      id: _generateId(),
      players: players,
      secretWord: '', // Se asignará después
      category: '',
      timePerPlayer: timePerPlayer,
      phase: GamePhase.setup,
    );

    return _currentGame!;
  }

  /// Asigna palabras y roles (llamar después de createGame)
  void assignRolesAndWord() {
    if (_currentGame == null) {
      throw StateError('No hay juego activo');
    }

    // Obtener palabra aleatoria
    final wordPair = WordService.getRandomWord();
    _currentGame!.secretWord = wordPair.word;
    _currentGame!.category = wordPair.category;

    // Asignar roles aleatorios
    Game.assignRoles(_currentGame!, _currentGame!.impostorCount);
  }

  /// Inicia la fase de revelación de roles
  void startRevealing() {
    _currentGame!.phase = GamePhase.revealing;
  }

  /// Avanza al siguiente jugador en la revelación
  bool nextRevealPlayer() {
    // Marcar jugador actual como revelado
    final current = _currentGame!.getCurrentPlayer();
    if (current != null) {
      current.status = PlayerStatus.revealed;
    }

    // Si todos han visto su rol, empezar juego
    if (_currentGame!.currentRound >= _currentGame!.totalPlayers) {
      _currentGame!.phase = GamePhase.playing;
      _currentGame!.currentRound = 1;
      return false; // No hay más jugadores
    }

    _currentGame!.currentRound++;
    return true; // Hay más jugadores
  }

  /// Inicia la ronda de juego
  void startGameRound() {
    _currentGame!.phase = GamePhase.playing;
    _currentGame!.currentRound = 1;
  }

  /// Finaliza el turno del jugador actual
  void nextPlayerTurn() {
    _currentGame!.currentRound++;
    if (_currentGame!.roundComplete) {
      _currentGame!.phase = GamePhase.voting;
    }
  }

  /// Procesa la votación
  void processVoting(Map<String, int> votes) {
    // Contar votos
    final voteCount = <Player, int>{};
    for (var player in _currentGame!.activePlayers) {
      final votesForPlayer = votes[player.id] ?? 0;
      voteCount[player] = votesForPlayer;
    }

    // Encontrar el jugador más votado
    Player? mostVoted;
    int maxVotes = 0;
    bool tie = false;

    voteCount.forEach((player, count) {
      if (count > maxVotes) {
        maxVotes = count;
        mostVoted = player;
        tie = false;
      } else if (count == maxVotes) {
        tie = true;
      }
    });

    // Si hay empate o nadie votó, nadie es eliminado
    if (tie || mostVoted == null || maxVotes == 0) {
      // Empate: nadie eliminado
      _currentGame!.phase = GamePhase.ended;
      _currentGame!.assignPoints(false); // Impostor gana
      return;
    }

    // Eliminar al jugador más votado
    mostVoted!.status = PlayerStatus.eliminated;

    // Verificar si el impostor fue eliminado
    bool impostorEliminated = mostVoted!.isImpostor;

    // Asignar puntos
    _currentGame!.assignPoints(impostorEliminated);

    // El juego termina después de una votación (una ronda nada más)
    _currentGame!.phase = GamePhase.ended;
  }

  /// Reinicia el juego manteniendo los mismos jugadores
  void resetGame() {
    if (_currentGame != null) {
      _currentGame!.resetGame();
    }
  }

  /// Finaliza el juego
  void endGame() {
    if (_currentGame != null) {
      _currentGame!.phase = GamePhase.ended;
    }
  }

  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}-${_random.nextInt(1000)}';
  }
}
