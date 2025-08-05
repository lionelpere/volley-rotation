import 'package:flutter/foundation.dart';

class Player {
  final int number;
  final String position;
  final bool isLibero;
  
  const Player({
    required this.number,
    required this.position,
    this.isLibero = false,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'position': position,
      'isLibero': isLibero,
    };
  }
  
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      number: json['number'] as int,
      position: json['position'] as String,
      isLibero: json['isLibero'] as bool? ?? false,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Player &&
        other.number == number &&
        other.position == position &&
        other.isLibero == isLibero;
  }
  
  @override
  int get hashCode => Object.hash(number, position, isLibero);
}

class LiberoRotation {
  final Player libero;
  final List<int> replacementOrder;
  
  const LiberoRotation({
    required this.libero,
    required this.replacementOrder,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'libero': libero.toJson(),
      'replacementOrder': replacementOrder,
    };
  }
  
  factory LiberoRotation.fromJson(Map<String, dynamic> json) {
    return LiberoRotation(
      libero: Player.fromJson(json['libero'] as Map<String, dynamic>),
      replacementOrder: (json['replacementOrder'] as List).cast<int>(),
    );
  }
}

class TeamRotation with ChangeNotifier {
  final String teamName;
  final Map<int, Player> _players;
  final LiberoRotation? _liberoRotation;
  
  TeamRotation({
    required this.teamName,
    Map<int, Player>? players,
    LiberoRotation? liberoRotation,
  }) : _players = players ?? _defaultPlayers(),
       _liberoRotation = liberoRotation;
  
  static Map<int, Player> _defaultPlayers() {
    return {
      1: const Player(number: 1, position: 'S'),
      2: const Player(number: 2, position: 'RS'),
      3: const Player(number: 3, position: 'MB'),
      4: const Player(number: 4, position: 'OH'),
      5: const Player(number: 5, position: 'OH'),
      6: const Player(number: 6, position: 'DS'),
    };
  }
  
  Map<int, Player> get players => Map.unmodifiable(_players);
  LiberoRotation? get liberoRotation => _liberoRotation;
  
  Player? getPlayerAtPosition(int position) {
    return _players[position];
  }
  
  void updatePlayer(int position, Player player) {
    if (position < 1 || position > 6) {
      throw ArgumentError('Position must be between 1 and 6');
    }
    _players[position] = player;
    notifyListeners();
  }
  
  void updateLiberoRotation(LiberoRotation liberoRotation) {
    final newRotation = TeamRotation(
      teamName: teamName,
      players: _players,
      liberoRotation: liberoRotation,
    );
    _copyFrom(newRotation);
    notifyListeners();
  }
  
  void _copyFrom(TeamRotation other) {
    _players.clear();
    _players.addAll(other._players);
  }
  
  void resetToDefault() {
    _players.clear();
    _players.addAll(_defaultPlayers());
    final newRotation = TeamRotation(
      teamName: teamName,
      players: _players,
      liberoRotation: null,
    );
    _copyFrom(newRotation);
    notifyListeners();
  }
  
  List<Map<int, Player>> getAllRotations() {
    List<Map<int, Player>> rotations = [];
    Map<int, Player> currentRotation = Map.from(_players);
    
    for (int i = 0; i < 6; i++) {
      rotations.add(Map.from(currentRotation));
      currentRotation = _rotateOnce(currentRotation);
    }
    
    return rotations;
  }
  
  Map<int, Player> _rotateOnce(Map<int, Player> rotation) {
    return {
      1: rotation[6]!,
      2: rotation[1]!,
      3: rotation[2]!,
      4: rotation[3]!,
      5: rotation[4]!,
      6: rotation[5]!,
    };
  }
  
  Map<String, dynamic> toJson() {
    return {
      'teamName': teamName,
      'players': _players.map((key, value) => MapEntry(key.toString(), value.toJson())),
      'liberoRotation': _liberoRotation?.toJson(),
    };
  }
  
  factory TeamRotation.fromJson(Map<String, dynamic> json) {
    final playersMap = <int, Player>{};
    final playersJson = json['players'] as Map<String, dynamic>;
    
    for (final entry in playersJson.entries) {
      playersMap[int.parse(entry.key)] = Player.fromJson(entry.value as Map<String, dynamic>);
    }
    
    LiberoRotation? liberoRotation;
    if (json['liberoRotation'] != null) {
      liberoRotation = LiberoRotation.fromJson(json['liberoRotation'] as Map<String, dynamic>);
    }
    
    return TeamRotation(
      teamName: json['teamName'] as String,
      players: playersMap,
      liberoRotation: liberoRotation,
    );
  }
}

class RotationManager with ChangeNotifier {
  TeamRotation _homeTeam;
  TeamRotation _opponentTeam;
  
  RotationManager({
    TeamRotation? homeTeam,
    TeamRotation? opponentTeam,
  }) : _homeTeam = homeTeam ?? TeamRotation(teamName: 'Home Team'),
       _opponentTeam = opponentTeam ?? TeamRotation(teamName: 'Opponent Team');
  
  TeamRotation get homeTeam => _homeTeam;
  TeamRotation get opponentTeam => _opponentTeam;
  
  void updateHomeTeam(TeamRotation team) {
    _homeTeam = team;
    notifyListeners();
  }
  
  void updateOpponentTeam(TeamRotation team) {
    _opponentTeam = team;
    notifyListeners();
  }
  
  List<Map<String, dynamic>> generateAllRotationCombinations() {
    final homeRotations = _homeTeam.getAllRotations();
    final opponentRotations = _opponentTeam.getAllRotations();
    
    List<Map<String, dynamic>> combinations = [];
    
    for (int homeIndex = 0; homeIndex < homeRotations.length; homeIndex++) {
      for (int opponentIndex = 0; opponentIndex < opponentRotations.length; opponentIndex++) {
        combinations.add({
          'homeRotation': homeIndex + 1,
          'opponentRotation': opponentIndex + 1,
          'homePlayers': homeRotations[homeIndex],
          'opponentPlayers': opponentRotations[opponentIndex],
        });
      }
    }
    
    return combinations;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'homeTeam': _homeTeam.toJson(),
      'opponentTeam': _opponentTeam.toJson(),
    };
  }
  
  factory RotationManager.fromJson(Map<String, dynamic> json) {
    return RotationManager(
      homeTeam: TeamRotation.fromJson(json['homeTeam'] as Map<String, dynamic>),
      opponentTeam: TeamRotation.fromJson(json['opponentTeam'] as Map<String, dynamic>),
    );
  }
}