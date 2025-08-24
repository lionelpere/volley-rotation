import 'package:json_annotation/json_annotation.dart';

part 'game_state.g.dart';

/// Represents the complete state of a volleyball rotation game
@JsonSerializable()
class GameState {
  final int teamAServing; // 1 = Team A serving, 0 = Team B serving
  final List<String> teamAPlayers;
  final List<String> teamBPlayers;
  final int teamAScore;
  final int teamBScore;
  final int teamARotations;
  final int teamBRotations;
  final bool matchOver;
  final String? winner; // 'A', 'B', or null

  const GameState({
    required this.teamAServing,
    required this.teamAPlayers,
    required this.teamBPlayers,
    required this.teamAScore,
    required this.teamBScore,
    required this.teamARotations,
    required this.teamBRotations,
    required this.matchOver,
    this.winner,
  });

  /// Creates initial game state
  factory GameState.initial() {
    return const GameState(
      teamAServing: 1,
      teamAPlayers: ['A1', 'A2', 'A3', 'A4', 'A5', 'A6'],
      teamBPlayers: ['B1', 'B2', 'B3', 'B4', 'B5', 'B6'],
      teamAScore: 0,
      teamBScore: 0,
      teamARotations: 0,
      teamBRotations: 0,
      matchOver: false,
      winner: null,
    );
  }

  /// Creates a copy with updated values
  GameState copyWith({
    int? teamAServing,
    List<String>? teamAPlayers,
    List<String>? teamBPlayers,
    int? teamAScore,
    int? teamBScore,
    int? teamARotations,
    int? teamBRotations,
    bool? matchOver,
    String? winner,
  }) {
    return GameState(
      teamAServing: teamAServing ?? this.teamAServing,
      teamAPlayers: teamAPlayers ?? List.from(this.teamAPlayers),
      teamBPlayers: teamBPlayers ?? List.from(this.teamBPlayers),
      teamAScore: teamAScore ?? this.teamAScore,
      teamBScore: teamBScore ?? this.teamBScore,
      teamARotations: teamARotations ?? this.teamARotations,
      teamBRotations: teamBRotations ?? this.teamBRotations,
      matchOver: matchOver ?? this.matchOver,
      winner: winner ?? this.winner,
    );
  }

  /// Checks if Team A is currently serving
  bool get isTeamAServing => teamAServing == 1;

  /// Checks if Team B is currently serving
  bool get isTeamBServing => teamAServing == 0;

  /// Gets the current serving team name
  String get servingTeam => isTeamAServing ? 'Team A' : 'Team B';

  /// Checks if the game has ended (25+ points with 2-point lead)
  bool _checkMatchEnd() {
    return (teamAScore >= 25 && teamAScore - teamBScore >= 2) ||
           (teamBScore >= 25 && teamBScore - teamAScore >= 2);
  }

  /// Determines the winner based on current scores
  String? _determineWinner() {
    if (teamAScore >= 25 && teamAScore - teamBScore >= 2) {
      return 'A';
    } else if (teamBScore >= 25 && teamBScore - teamAScore >= 2) {
      return 'B';
    }
    return null;
  }

  /// Updates game state after Team A scores
  GameState teamAScores() {
    final newScore = teamAScore + 1;
    final shouldRotate = !isTeamAServing;
    final newRotations = shouldRotate ? teamARotations + 1 : teamARotations;
    final newPlayers = shouldRotate ? _rotateTeamAClockwise() : teamAPlayers;
    
    final updatedState = copyWith(
      teamAScore: newScore,
      teamAServing: 1, // Team A gains serve
      teamARotations: newRotations,
      teamAPlayers: newPlayers,
    );

    final isMatchOver = updatedState._checkMatchEnd();
    final winner = updatedState._determineWinner();

    return updatedState.copyWith(
      matchOver: isMatchOver,
      winner: winner,
    );
  }

  /// Updates game state after Team B scores
  GameState teamBScores() {
    final newScore = teamBScore + 1;
    final shouldRotate = !isTeamBServing;
    final newRotations = shouldRotate ? teamBRotations + 1 : teamBRotations;
    final newPlayers = shouldRotate ? _rotateTeamBClockwise() : teamBPlayers;
    
    final updatedState = copyWith(
      teamBScore: newScore,
      teamAServing: 0, // Team B gains serve
      teamBRotations: newRotations,
      teamBPlayers: newPlayers,
    );

    final isMatchOver = updatedState._checkMatchEnd();
    final winner = updatedState._determineWinner();

    return updatedState.copyWith(
      matchOver: isMatchOver,
      winner: winner,
    );
  }

  /// Rotates Team A players clockwise (last player moves to front)
  List<String> _rotateTeamAClockwise() {
    final players = List<String>.from(teamAPlayers);
    final last = players.removeLast();
    players.insert(0, last);
    return players;
  }

  /// Rotates Team B players clockwise (last player moves to front)
  List<String> _rotateTeamBClockwise() {
    final players = List<String>.from(teamBPlayers);
    final last = players.removeLast();
    players.insert(0, last);
    return players;
  }

  /// Resets the game to initial state
  GameState reset() => GameState.initial();

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  Map<String, dynamic> toJson() => _$GameStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameState &&
          runtimeType == other.runtimeType &&
          teamAServing == other.teamAServing &&
          _listEquals(teamAPlayers, other.teamAPlayers) &&
          _listEquals(teamBPlayers, other.teamBPlayers) &&
          teamAScore == other.teamAScore &&
          teamBScore == other.teamBScore &&
          teamARotations == other.teamARotations &&
          teamBRotations == other.teamBRotations &&
          matchOver == other.matchOver &&
          winner == other.winner;

  @override
  int get hashCode =>
      teamAServing.hashCode ^
      teamAPlayers.hashCode ^
      teamBPlayers.hashCode ^
      teamAScore.hashCode ^
      teamBScore.hashCode ^
      teamARotations.hashCode ^
      teamBRotations.hashCode ^
      matchOver.hashCode ^
      winner.hashCode;

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'GameState{teamAServing: $teamAServing, teamAPlayers: $teamAPlayers, '
           'teamBPlayers: $teamBPlayers, teamAScore: $teamAScore, '
           'teamBScore: $teamBScore, teamARotations: $teamARotations, '
           'teamBRotations: $teamBRotations, matchOver: $matchOver, winner: $winner}';
  }
}