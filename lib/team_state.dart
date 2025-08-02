import 'package:flutter/material.dart';

class TeamState extends ChangeNotifier {
  // État des joueurs de l'équipe principale
  Map<String, String> _homeTeamPlayers = {
    'pos1': '1',
    'pos2': '2',
    'pos3': '3',
    'pos4': '4',
    'pos5': '5',
    'pos6': '6',
    'libero': 'L',
  };

  // État des joueurs de l'équipe adverse
  Map<String, String> _opponentTeamPlayers = {
    'pos1': '1',
    'pos2': '2',
    'pos3': '3',
    'pos4': '4',
    'pos5': '5',
    'pos6': '6',
    'libero': 'L',
  };

  // Getters pour accéder aux données
  Map<String, String> get homeTeamPlayers => Map.from(_homeTeamPlayers);
  Map<String, String> get opponentTeamPlayers => Map.from(_opponentTeamPlayers);

  // Méthodes pour modifier l'équipe principale
  void updateHomePlayer(String position, String number) {
    _homeTeamPlayers[position] = number.isEmpty ? '?' : number;
    notifyListeners();
  }

  String getHomePlayer(String position) {
    return _homeTeamPlayers[position] ?? '?';
  }

  // Méthodes pour modifier l'équipe adverse
  void updateOpponentPlayer(String position, String number) {
    _opponentTeamPlayers[position] = number.isEmpty ? '?' : number;
    notifyListeners();
  }

  String getOpponentPlayer(String position) {
    return _opponentTeamPlayers[position] ?? '?';
  }

  // Méthodes pour réinitialiser les équipes
  void resetHomeTeam() {
    _homeTeamPlayers = {
      'pos1': '1',
      'pos2': '2',
      'pos3': '3',
      'pos4': '4',
      'pos5': '5',
      'pos6': '6',
      'libero': 'L',
    };
    notifyListeners();
  }

  void resetOpponentTeam() {
    _opponentTeamPlayers = {
      'pos1': '1',
      'pos2': '2',
      'pos3': '3',
      'pos4': '4',
      'pos5': '5',
      'pos6': '6',
      'libero': 'L',
    };
    notifyListeners();
  }

  void resetBothTeams() {
    resetHomeTeam();
    resetOpponentTeam();
  }
}