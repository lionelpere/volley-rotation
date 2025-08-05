import 'package:equatable/equatable.dart';

enum PlayerRole {
  setter('S', 'Setter'),
  outsideHitter('OH', 'Outside Hitter'),
  oppositeHitter('OPP', 'Opposite Hitter'),
  middleBlocker('MB', 'Middle Blocker'),
  libero('L', 'Libero'),
  defensiveSpecialist('DS', 'Defensive Specialist');

  const PlayerRole(this.code, this.name);
  
  final String code;
  final String name;
}

class Player extends Equatable {
  final String id;
  final int jerseyNumber;
  final String? name;
  final PlayerRole role;
  final bool isLibero;
  final String? liberoReplacesPlayerId;

  const Player({
    required this.id,
    required this.jerseyNumber,
    this.name,
    required this.role,
    this.isLibero = false,
    this.liberoReplacesPlayerId,
  });

  Player copyWith({
    String? id,
    int? jerseyNumber,
    String? name,
    PlayerRole? role,
    bool? isLibero,
    String? liberoReplacesPlayerId,
  }) {
    return Player(
      id: id ?? this.id,
      jerseyNumber: jerseyNumber ?? this.jerseyNumber,
      name: name ?? this.name,
      role: role ?? this.role,
      isLibero: isLibero ?? this.isLibero,
      liberoReplacesPlayerId: liberoReplacesPlayerId ?? this.liberoReplacesPlayerId,
    );
  }

  String get displayName => name ?? '#$jerseyNumber';
  String get shortDisplayName => isLibero ? 'L$jerseyNumber' : '$jerseyNumber';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jerseyNumber': jerseyNumber,
      'name': name,
      'role': role.code,
      'isLibero': isLibero,
      'liberoReplacesPlayerId': liberoReplacesPlayerId,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      jerseyNumber: json['jerseyNumber'] as int,
      name: json['name'] as String?,
      role: PlayerRole.values.firstWhere(
        (role) => role.code == json['role'],
        orElse: () => PlayerRole.setter,
      ),
      isLibero: json['isLibero'] as bool? ?? false,
      liberoReplacesPlayerId: json['liberoReplacesPlayerId'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        jerseyNumber,
        name,
        role,
        isLibero,
        liberoReplacesPlayerId,
      ];
}