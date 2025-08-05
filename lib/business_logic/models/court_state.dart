import 'package:equatable/equatable.dart';
import 'position.dart';

enum LiberoState {
  onCourt('On Court'),
  offCourt('Off Court'),
  rotating('Rotating');

  const LiberoState(this.description);
  
  final String description;
}

class CourtState extends Equatable {
  final int rotationNumber;
  final Map<Position, String> homeTeamPositions;
  final Map<Position, String> visitorTeamPositions;
  final bool homeTeamIsServing;
  final LiberoState homeLiberoState;
  final LiberoState visitorLiberoState;

  const CourtState({
    required this.rotationNumber,
    required this.homeTeamPositions,
    required this.visitorTeamPositions,
    required this.homeTeamIsServing,
    this.homeLiberoState = LiberoState.offCourt,
    this.visitorLiberoState = LiberoState.offCourt,
  });

  CourtState copyWith({
    int? rotationNumber,
    Map<Position, String>? homeTeamPositions,
    Map<Position, String>? visitorTeamPositions,
    bool? homeTeamIsServing,
    LiberoState? homeLiberoState,
    LiberoState? visitorLiberoState,
  }) {
    return CourtState(
      rotationNumber: rotationNumber ?? this.rotationNumber,
      homeTeamPositions: homeTeamPositions ?? this.homeTeamPositions,
      visitorTeamPositions: visitorTeamPositions ?? this.visitorTeamPositions,
      homeTeamIsServing: homeTeamIsServing ?? this.homeTeamIsServing,
      homeLiberoState: homeLiberoState ?? this.homeLiberoState,
      visitorLiberoState: visitorLiberoState ?? this.visitorLiberoState,
    );
  }

  /// Returns the player ID of the current server
  String get servingPlayerId {
    return homeTeamIsServing 
      ? homeTeamPositions[Position.p1]!
      : visitorTeamPositions[Position.p1]!;
  }

  /// Returns positions of players at the net (front row)
  Map<Position, String> get homeTeamNetPositions {
    return Map.fromEntries(
      homeTeamPositions.entries.where((entry) => entry.key.isFrontRow),
    );
  }

  Map<Position, String> get visitorTeamNetPositions {
    return Map.fromEntries(
      visitorTeamPositions.entries.where((entry) => entry.key.isFrontRow),
    );
  }

  /// Returns positions of players in back row (potential receivers)
  Map<Position, String> get homeTeamBackRowPositions {
    return Map.fromEntries(
      homeTeamPositions.entries.where((entry) => entry.key.isBackRow),
    );
  }

  Map<Position, String> get visitorTeamBackRowPositions {
    return Map.fromEntries(
      visitorTeamPositions.entries.where((entry) => entry.key.isBackRow),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rotationNumber': rotationNumber,
      'homeTeamPositions': homeTeamPositions.map(
        (key, value) => MapEntry(key.number.toString(), value),
      ),
      'visitorTeamPositions': visitorTeamPositions.map(
        (key, value) => MapEntry(key.number.toString(), value),
      ),
      'homeTeamIsServing': homeTeamIsServing,
      'homeLiberoState': homeLiberoState.name,
      'visitorLiberoState': visitorLiberoState.name,
    };
  }

  factory CourtState.fromJson(Map<String, dynamic> json) {
    final homePositionsJson = json['homeTeamPositions'] as Map<String, dynamic>;
    final homeTeamPositions = <Position, String>{};
    for (final entry in homePositionsJson.entries) {
      final position = Position.fromNumber(int.parse(entry.key));
      homeTeamPositions[position] = entry.value as String;
    }

    final visitorPositionsJson = json['visitorTeamPositions'] as Map<String, dynamic>;
    final visitorTeamPositions = <Position, String>{};
    for (final entry in visitorPositionsJson.entries) {
      final position = Position.fromNumber(int.parse(entry.key));
      visitorTeamPositions[position] = entry.value as String;
    }

    return CourtState(
      rotationNumber: json['rotationNumber'] as int,
      homeTeamPositions: homeTeamPositions,
      visitorTeamPositions: visitorTeamPositions,
      homeTeamIsServing: json['homeTeamIsServing'] as bool,
      homeLiberoState: LiberoState.values.firstWhere(
        (state) => state.name == json['homeLiberoState'],
        orElse: () => LiberoState.offCourt,
      ),
      visitorLiberoState: LiberoState.values.firstWhere(
        (state) => state.name == json['visitorLiberoState'],
        orElse: () => LiberoState.offCourt,
      ),
    );
  }

  @override
  List<Object?> get props => [
        rotationNumber,
        homeTeamPositions,
        visitorTeamPositions,
        homeTeamIsServing,
        homeLiberoState,
        visitorLiberoState,
      ];
}