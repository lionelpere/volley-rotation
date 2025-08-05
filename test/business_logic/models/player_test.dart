import 'package:flutter_test/flutter_test.dart';
import 'package:volley_rotation/business_logic/models/player.dart';

void main() {
  group('PlayerRole', () {
    test('should have correct properties', () {
      expect(PlayerRole.setter.code, equals('S'));
      expect(PlayerRole.setter.name, equals('Setter'));
      
      expect(PlayerRole.libero.code, equals('L'));
      expect(PlayerRole.libero.name, equals('Libero'));
    });
  });

  group('Player', () {
    late Player testPlayer;
    late Player liberoPlayer;

    setUp(() {
      testPlayer = const Player(
        id: 'player1',
        jerseyNumber: 10,
        name: 'John Doe',
        role: PlayerRole.setter,
      );

      liberoPlayer = const Player(
        id: 'libero1',
        jerseyNumber: 5,
        name: 'Jane Smith',
        role: PlayerRole.libero,
        isLibero: true,
        liberoReplacesPlayerId: 'player2',
      );
    });

    test('should create player with required properties', () {
      expect(testPlayer.id, equals('player1'));
      expect(testPlayer.jerseyNumber, equals(10));
      expect(testPlayer.name, equals('John Doe'));
      expect(testPlayer.role, equals(PlayerRole.setter));
      expect(testPlayer.isLibero, isFalse);
      expect(testPlayer.liberoReplacesPlayerId, isNull);
    });

    test('should create libero player correctly', () {
      expect(liberoPlayer.isLibero, isTrue);
      expect(liberoPlayer.role, equals(PlayerRole.libero));
      expect(liberoPlayer.liberoReplacesPlayerId, equals('player2'));
    });

    test('displayName should return name or jersey number', () {
      expect(testPlayer.displayName, equals('John Doe'));
      
      final playerWithoutName = const Player(
        id: 'player1',
        jerseyNumber: 10,
        role: PlayerRole.setter,
      );
      expect(playerWithoutName.displayName, equals('#10'));
    });

    test('shortDisplayName should handle libero correctly', () {
      expect(testPlayer.shortDisplayName, equals('10'));
      expect(liberoPlayer.shortDisplayName, equals('L5'));
    });

    test('copyWith should create new instance with updated fields', () {
      final updated = testPlayer.copyWith(
        name: 'Updated Name',
        jerseyNumber: 99,
      );

      expect(updated.name, equals('Updated Name'));
      expect(updated.jerseyNumber, equals(99));
      expect(updated.id, equals(testPlayer.id)); // unchanged
      expect(updated.role, equals(testPlayer.role)); // unchanged
    });

    test('toJson should serialize correctly', () {
      final json = testPlayer.toJson();
      
      expect(json['id'], equals('player1'));
      expect(json['jerseyNumber'], equals(10));
      expect(json['name'], equals('John Doe'));
      expect(json['role'], equals('S'));
      expect(json['isLibero'], isFalse);
      expect(json['liberoReplacesPlayerId'], isNull);
    });

    test('fromJson should deserialize correctly', () {
      final json = {
        'id': 'player1',
        'jerseyNumber': 10,
        'name': 'John Doe',
        'role': 'S',
        'isLibero': false,
        'liberoReplacesPlayerId': null,
      };

      final player = Player.fromJson(json);
      
      expect(player.id, equals('player1'));
      expect(player.jerseyNumber, equals(10));
      expect(player.name, equals('John Doe'));
      expect(player.role, equals(PlayerRole.setter));
      expect(player.isLibero, isFalse);
      expect(player.liberoReplacesPlayerId, isNull);
    });

    test('fromJson should handle missing optional fields', () {
      final json = {
        'id': 'player1',
        'jerseyNumber': 10,
        'role': 'OH',
      };

      final player = Player.fromJson(json);
      
      expect(player.name, isNull);
      expect(player.isLibero, isFalse);
      expect(player.liberoReplacesPlayerId, isNull);
    });

    test('equality should work correctly', () {
      final player1 = const Player(
        id: 'p1',
        jerseyNumber: 1,
        role: PlayerRole.setter,
      );
      
      final player2 = const Player(
        id: 'p1',
        jerseyNumber: 1,
        role: PlayerRole.setter,
      );
      
      final player3 = const Player(
        id: 'p1',
        jerseyNumber: 2, // different jersey number
        role: PlayerRole.setter,
      );

      expect(player1, equals(player2));
      expect(player1, isNot(equals(player3)));
    });
  });
}