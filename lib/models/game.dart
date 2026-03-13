import 'player.dart';

enum GamePhase { setup, revealing, playing, voting, ended }

class Game {
  final String id;
  List<Player> players;
  String secretWord;
  String category;
  int currentRound;
  GamePhase phase;
  int timePerPlayer; // segundos por jugador
  DateTime? createdAt;

  Game({
    required this.id,
    required this.players,
    required this.secretWord,
    required this.category,
    this.currentRound = 1,
    this.phase = GamePhase.setup,
    this.timePerPlayer = 15,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get totalPlayers => players.length;
  int get impostorCount => players.where((p) => p.role == PlayerRole.impostor).length;
  int get citizenCount => players.where((p) => p.role == PlayerRole.citizen).length;
  
  List<Player> get activePlayers => players.where((p) => !p.isEliminated).toList();
  List<Player> get eliminatedPlayers => players.where((p) => p.isEliminated).toList();
  
  Player? getImpostor() {
    try {
      return players.firstWhere((p) => p.role == PlayerRole.impostor);
    } catch (e) {
      return null;
    }
  }

  bool get hasImpostor => getImpostor() != null;

  // Tiempo total de ronda en segundos
  int get totalRoundTime => timePerPlayer * activePlayers.length;

  // Jugador actual (índice basado en ronda)
  Player? getCurrentPlayer() {
    if (phase != GamePhase.playing && phase != GamePhase.revealing) {
      return null;
    }
    int index = (currentRound - 1) % activePlayers.length;
    return activePlayers[index];
  }

  // Averiguar si todos los jugadores han jugado esta ronda
  bool get roundComplete => currentRound > activePlayers.length;

  // Reiniciar ronda
  void nextRound() {
    if (roundComplete) {
      phase = GamePhase.voting;
    } else {
      currentRound++;
    }
  }

  // Reiniciar juego completo
  void resetGame() {
    for (var player in players) {
      player.status = PlayerStatus.waiting;
      player.score = 0;
    }
    currentRound = 1;
    phase = GamePhase.setup;
  }

  // Asignar roles aleatoriamente
  static void assignRoles(Game game, int impostorCount) {
    final random = List<Player>.from(game.players)..shuffle();
    
    // Resetear roles primero
    for (var player in game.players) {
      player = player.copyWith(role: PlayerRole.citizen);
    }
    
    // Asignar impostores
    for (int i = 0; i < impostorCount && i < random.length; i++) {
      random[i] = random[i].copyWith(role: PlayerRole.impostor);
    }
    
    // Actualizar la lista original
    game.players = random;
  }

  // Calcular ganador (después de votación)
  bool impostorWins() {
    final impostor = getImpostor();
    if (impostor == null) return false;
    return !impostor.isEliminated;
  }

  // Asignar puntos
  void assignPoints(bool impostorWasEliminated) {
    if (impostorWasEliminated) {
      // Ciudadanos ganan: +1 todos los ciudadanos vivos
      for (var player in players) {
        if (player.isCitizen && !player.isEliminated) {
          player.score++;
        }
      }
    } else {
      // Impostor gana: +1 al impostor si no lo descubrieron
      final impostor = getImpostor();
      if (impostor != null && !impostor.isEliminated) {
        impostor.score++;
      }
    }
  }

  Game copyWith({
    String? id,
    List<Player>? players,
    String? secretWord,
    String? category,
    int? currentRound,
    GamePhase? phase,
    int? timePerPlayer,
    DateTime? createdAt,
  }) {
    return Game(
      id: id ?? this.id,
      players: players ?? this.players,
      secretWord: secretWord ?? this.secretWord,
      category: category ?? this.category,
      currentRound: currentRound ?? this.currentRound,
      phase: phase ?? this.phase,
      timePerPlayer: timePerPlayer ?? this.timePerPlayer,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Game{id: $id, players: ${players.length}, secretWord: $secretWord, '
        'category: $category, currentRound: $currentRound, phase: $phase}';
  }
}
