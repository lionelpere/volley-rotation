import 'package:flutter/material.dart';
import 'rotation_model.dart';
import 'persistence_service.dart';

class TeamState extends ChangeNotifier {
  RotationManager _rotationManager = RotationManager();
  bool _isInitialized = false;
  TeamState() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    if (_isInitialized) return;
    
    final savedManager = await PersistenceService.loadRotationManager();
    if (savedManager != null) {
      _rotationManager = savedManager;
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  RotationManager get rotationManager => _rotationManager;

  // Méthodes de compatibilité avec l'ancien système
  Map<String, String> get homeTeamPlayers {
    final players = _rotationManager.homeTeam.players;
    return {
      'pos1': players[1]?.number.toString() ?? '1',
      'pos2': players[2]?.number.toString() ?? '2',
      'pos3': players[3]?.number.toString() ?? '3',
      'pos4': players[4]?.number.toString() ?? '4',
      'pos5': players[5]?.number.toString() ?? '5',
      'pos6': players[6]?.number.toString() ?? '6',
      'libero': _rotationManager.homeTeam.liberoRotation?.libero.number.toString() ?? 'L',
    };
  }

  Map<String, String> get opponentTeamPlayers {
    final players = _rotationManager.opponentTeam.players;
    return {
      'pos1': players[1]?.number.toString() ?? '1',
      'pos2': players[2]?.number.toString() ?? '2',
      'pos3': players[3]?.number.toString() ?? '3',
      'pos4': players[4]?.number.toString() ?? '4',
      'pos5': players[5]?.number.toString() ?? '5',
      'pos6': players[6]?.number.toString() ?? '6',
      'libero': _rotationManager.opponentTeam.liberoRotation?.libero.number.toString() ?? 'L',
    };
  }

  // Méthodes pour modifier l'équipe principale
  void updateHomePlayer(String position, String number) {
    if (position == 'libero') {
      _updateLibero(true, number);
    } else {
      final posIndex = _getPositionIndex(position);
      if (posIndex != null) {
        final playerNumber = int.tryParse(number) ?? 0;
        final currentPlayer = _rotationManager.homeTeam.getPlayerAtPosition(posIndex);
        final newPlayer = Player(
          number: playerNumber,
          position: currentPlayer?.position ?? 'S',
        );
        _rotationManager.homeTeam.updatePlayer(posIndex, newPlayer);
      }
    }
    _saveData();
    notifyListeners();
  }

  String getHomePlayer(String position) {
    if (position == 'libero') {
      return _rotationManager.homeTeam.liberoRotation?.libero.number.toString() ?? 'L';
    }
    final posIndex = _getPositionIndex(position);
    if (posIndex != null) {
      return _rotationManager.homeTeam.getPlayerAtPosition(posIndex)?.number.toString() ?? '?';
    }
    return '?';
  }

  // Méthodes pour modifier l'équipe adverse
  void updateOpponentPlayer(String position, String number) {
    if (position == 'libero') {
      _updateLibero(false, number);
    } else {
      final posIndex = _getPositionIndex(position);
      if (posIndex != null) {
        final playerNumber = int.tryParse(number) ?? 0;
        final currentPlayer = _rotationManager.opponentTeam.getPlayerAtPosition(posIndex);
        final newPlayer = Player(
          number: playerNumber,
          position: currentPlayer?.position ?? 'S',
        );
        _rotationManager.opponentTeam.updatePlayer(posIndex, newPlayer);
      }
    }
    _saveData();
    notifyListeners();
  }

  String getOpponentPlayer(String position) {
    if (position == 'libero') {
      return _rotationManager.opponentTeam.liberoRotation?.libero.number.toString() ?? 'L';
    }
    final posIndex = _getPositionIndex(position);
    if (posIndex != null) {
      return _rotationManager.opponentTeam.getPlayerAtPosition(posIndex)?.number.toString() ?? '?';
    }
    return '?';
  }

  int? _getPositionIndex(String position) {
    switch (position) {
      case 'pos1': return 1;
      case 'pos2': return 2;
      case 'pos3': return 3;
      case 'pos4': return 4;
      case 'pos5': return 5;
      case 'pos6': return 6;
      default: return null;
    }
  }

  void _updateLibero(bool isHomeTeam, String number) {
    final playerNumber = int.tryParse(number) ?? 0;
    final libero = Player(number: playerNumber, position: 'L', isLibero: true);
    final liberoRotation = LiberoRotation(
      libero: libero,
      replacementOrder: [3, 6], // Par défaut remplace les centraux
    );
    
    if (isHomeTeam) {
      _rotationManager.homeTeam.updateLiberoRotation(liberoRotation);
    } else {
      _rotationManager.opponentTeam.updateLiberoRotation(liberoRotation);
    }
  }

  // Méthodes pour réinitialiser les équipes
  void resetHomeTeam() {
    _rotationManager.homeTeam.resetToDefault();
    _saveData();
    notifyListeners();
  }

  void resetOpponentTeam() {
    _rotationManager.opponentTeam.resetToDefault();
    _saveData();
    notifyListeners();
  }

  void resetBothTeams() {
    resetHomeTeam();
    resetOpponentTeam();
  }

  Future<void> _saveData() async {
    await PersistenceService.saveRotationManager(_rotationManager);
  }

  List<Map<String, dynamic>> generateAllRotationCombinations() {
    return _rotationManager.generateAllRotationCombinations();
  }
}