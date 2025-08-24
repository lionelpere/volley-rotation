import 'package:flutter/foundation.dart';
import '../models/game_state.dart';

/// Provider for managing volleyball rotation game state
class RotationProvider extends ChangeNotifier {
  GameState _gameState = GameState.initial();

  /// Current game state
  GameState get gameState => _gameState;

  /// Team A players in current rotation order
  List<String> get teamAPlayers => _gameState.teamAPlayers;

  /// Team B players in current rotation order
  List<String> get teamBPlayers => _gameState.teamBPlayers;

  /// Team A current score
  int get teamAScore => _gameState.teamAScore;

  /// Team B current score
  int get teamBScore => _gameState.teamBScore;

  /// Team A total rotations
  int get teamARotations => _gameState.teamARotations;

  /// Team B total rotations
  int get teamBRotations => _gameState.teamBRotations;

  /// Which team is currently serving (1 = Team A, 0 = Team B)
  int get teamAServing => _gameState.teamAServing;

  /// Whether Team A is currently serving
  bool get isTeamAServing => _gameState.isTeamAServing;

  /// Whether Team B is currently serving
  bool get isTeamBServing => _gameState.isTeamBServing;

  /// Current serving team name
  String get servingTeam => _gameState.servingTeam;

  /// Whether the match is over
  bool get matchOver => _gameState.matchOver;

  /// Winner of the match ('A', 'B', or null)
  String? get winner => _gameState.winner;

  /// Handles Team A scoring a point
  void teamAScores() {
    _gameState = _gameState.teamAScores();
    notifyListeners();
  }

  /// Handles Team B scoring a point
  void teamBScores() {
    _gameState = _gameState.teamBScores();
    notifyListeners();
  }

  /// Manually rotates Team A (for demonstration purposes)
  void rotateTeamAManually() {
    final rotatedPlayers = List<String>.from(_gameState.teamAPlayers);
    final last = rotatedPlayers.removeLast();
    rotatedPlayers.insert(0, last);
    
    _gameState = _gameState.copyWith(
      teamAPlayers: rotatedPlayers,
      teamARotations: _gameState.teamARotations + 1,
    );
    notifyListeners();
  }

  /// Manually rotates Team B (for demonstration purposes)
  void rotateTeamBManually() {
    final rotatedPlayers = List<String>.from(_gameState.teamBPlayers);
    final last = rotatedPlayers.removeLast();
    rotatedPlayers.insert(0, last);
    
    _gameState = _gameState.copyWith(
      teamBPlayers: rotatedPlayers,
      teamBRotations: _gameState.teamBRotations + 1,
    );
    notifyListeners();
  }

  /// Resets the game to initial state
  void resetGame() {
    _gameState = GameState.initial();
    notifyListeners();
  }

  /// Updates Team A player at specific index
  void updateTeamAPlayer(int index, String playerId) {
    if (index >= 0 && index < _gameState.teamAPlayers.length) {
      final updatedPlayers = List<String>.from(_gameState.teamAPlayers);
      updatedPlayers[index] = playerId;
      _gameState = _gameState.copyWith(teamAPlayers: updatedPlayers);
      notifyListeners();
    }
  }

  /// Updates Team B player at specific index
  void updateTeamBPlayer(int index, String playerId) {
    if (index >= 0 && index < _gameState.teamBPlayers.length) {
      final updatedPlayers = List<String>.from(_gameState.teamBPlayers);
      updatedPlayers[index] = playerId;
      _gameState = _gameState.copyWith(teamBPlayers: updatedPlayers);
      notifyListeners();
    }
  }
}