import 'package:equatable/equatable.dart';
import 'player.dart';
import 'position.dart';

class Team extends Equatable {
  final String id;
  final String name;
  final List<Player> players;
  final Map<Position, String> initialPositions;
  final String startingServerId;

  const Team({
    required this.id,
    required this.name,
    required this.players,
    required this.initialPositions,
    required this.startingServerId,
  });

  Team copyWith({
    String? id,
    String? name,
    List<Player>? players,
    Map<Position, String>? initialPositions,
    String? startingServerId,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      players: players ?? this.players,
      initialPositions: initialPositions ?? this.initialPositions,
      startingServerId: startingServerId ?? this.startingServerId,
    );
  }

  Player? getPlayerById(String id) {
    try {
      return players.firstWhere((player) => player.id == id);
    } catch (e) {
      return null;
    }
  }

  Player? get libero {
    try {
      return players.firstWhere((player) => player.isLibero);
    } catch (e) {
      return null;
    }
  }

  bool get hasLibero => libero != null;

  /// Validates if the team configuration is valid
  bool get isValid {
    // Must have exactly 6 players
    if (players.length != 6) return false;
    
    // Jersey numbers must be unique
    final jerseyNumbers = players.map((p) => p.jerseyNumber).toList();
    if (jerseyNumbers.length != jerseyNumbers.toSet().length) return false;
    
    // IDs must be unique
    final ids = players.map((p) => p.id).toList();
    if (ids.length != ids.toSet().length) return false;
    
    // Must have all 6 positions assigned
    if (initialPositions.length != 6) return false;
    
    // All positions must be assigned to valid player IDs
    for (final playerId in initialPositions.values) {
      if (getPlayerById(playerId) == null) return false;
    }
    
    // Starting server must be a valid player
    if (getPlayerById(startingServerId) == null) return false;
    
    // Can only have one libero
    final liberos = players.where((p) => p.isLibero).toList();
    if (liberos.length > 1) return false;
    
    return true;
  }

  List<String> get validationErrors {
    final errors = <String>[];
    
    if (players.length != 6) {
      errors.add('Team must have exactly 6 players (current: ${players.length})');
    }
    
    final jerseyNumbers = players.map((p) => p.jerseyNumber).toList();
    final uniqueJerseyNumbers = jerseyNumbers.toSet();
    if (jerseyNumbers.length != uniqueJerseyNumbers.length) {
      errors.add('Jersey numbers must be unique');
    }
    
    final ids = players.map((p) => p.id).toList();
    final uniqueIds = ids.toSet();
    if (ids.length != uniqueIds.length) {
      errors.add('Player IDs must be unique');
    }
    
    if (initialPositions.length != 6) {
      errors.add('All 6 positions must be assigned');
    }
    
    for (final entry in initialPositions.entries) {
      if (getPlayerById(entry.value) == null) {
        errors.add('Position ${entry.key.shortName} assigned to invalid player ID: ${entry.value}');
      }
    }
    
    if (getPlayerById(startingServerId) == null) {
      errors.add('Starting server ID is invalid: $startingServerId');
    }
    
    final liberos = players.where((p) => p.isLibero).toList();
    if (liberos.length > 1) {
      errors.add('Team can only have one libero');
    }
    
    return errors;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'players': players.map((p) => p.toJson()).toList(),
      'initialPositions': initialPositions.map(
        (key, value) => MapEntry(key.number.toString(), value),
      ),
      'startingServerId': startingServerId,
    };
  }

  factory Team.fromJson(Map<String, dynamic> json) {
    final players = (json['players'] as List)
        .map((playerJson) => Player.fromJson(playerJson as Map<String, dynamic>))
        .toList();

    final initialPositionsJson = json['initialPositions'] as Map<String, dynamic>;
    final initialPositions = <Position, String>{};
    
    for (final entry in initialPositionsJson.entries) {
      final position = Position.fromNumber(int.parse(entry.key));
      initialPositions[position] = entry.value as String;
    }

    return Team(
      id: json['id'] as String,
      name: json['name'] as String,
      players: players,
      initialPositions: initialPositions,
      startingServerId: json['startingServerId'] as String,
    );
  }

  @override
  List<Object?> get props => [id, name, players, initialPositions, startingServerId];
}