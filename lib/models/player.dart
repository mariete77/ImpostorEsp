enum PlayerRole { impostor, citizen }

enum PlayerStatus { waiting, revealed, eliminated, playing }

class Player {
  final String id;
  final String name;
  final PlayerRole role;
  final PlayerStatus status;
  int score;

  Player({
    required this.id,
    required this.name,
    required this.role,
    this.status = PlayerStatus.waiting,
    this.score = 0,
  });

  bool get isImpostor => role == PlayerRole.impostor;
  bool get isCitizen => role == PlayerRole.citizen;
  bool get isEliminated => status == PlayerStatus.eliminated;

  Player copyWith({
    String? id,
    String? name,
    PlayerRole? role,
    PlayerStatus? status,
    int? score,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      status: status ?? this.status,
      score: score ?? this.score,
    );
  }

  @override
  String toString() {
    return 'Player{id: $id, name: $name, role: $role, status: $status, score: $score}';
  }
}
