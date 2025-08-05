import 'package:flutter_test/flutter_test.dart';
import 'package:volley_rotation/business_logic/models/position.dart';
import 'package:volley_rotation/business_logic/models/player.dart';
import 'package:volley_rotation/business_logic/models/team.dart';
import 'package:volley_rotation/business_logic/providers/rotation_provider.dart';

void main() {
  group('RotationProvider', () {
    late RotationProvider provider;
    late Team homeTeam;
    late Team visitorTeam;

    setUp(() {
      provider = RotationProvider();

      // Create test teams
      final homePlayers = [
        const Player(id: 'h1', jerseyNumber: 1, role: PlayerRole.setter),
        const Player(id: 'h2', jerseyNumber: 2, role: PlayerRole.outsideHitter),
        const Player(id: 'h3', jerseyNumber: 3, role: PlayerRole.middleBlocker),
        const Player(id: 'h4', jerseyNumber: 4, role: PlayerRole.outsideHitter),
        const Player(id: 'h5', jerseyNumber: 5, role: PlayerRole.oppositeHitter),
        const Player(id: 'h6', jerseyNumber: 6, role: PlayerRole.defensiveSpecialist),
      ];

      final visitorPlayers = [
        const Player(id: 'v1', jerseyNumber: 11, role: PlayerRole.setter),
        const Player(id: 'v2', jerseyNumber: 12, role: PlayerRole.outsideHitter),
        const Player(id: 'v3', jerseyNumber: 13, role: PlayerRole.middleBlocker),
        const Player(id: 'v4', jerseyNumber: 14, role: PlayerRole.outsideHitter),
        const Player(id: 'v5', jerseyNumber: 15, role: PlayerRole.oppositeHitter),
        const Player(id: 'v6', jerseyNumber: 16, role: PlayerRole.defensiveSpecialist),
      ];

      homeTeam = Team(
        id: 'home',
        name: 'Home Team',
        players: homePlayers,
        initialPositions: {
          Position.p1: 'h1',
          Position.p2: 'h2',
          Position.p3: 'h3',
          Position.p4: 'h4',
          Position.p5: 'h5',
          Position.p6: 'h6',
        },
        startingServerId: 'h1',
      );

      visitorTeam = Team(
        id: 'visitor',
        name: 'Visitor Team',
        players: visitorPlayers,
        initialPositions: {
          Position.p1: 'v1',
          Position.p2: 'v2',
          Position.p3: 'v3',
          Position.p4: 'v4',
          Position.p5: 'v5',
          Position.p6: 'v6',
        },
        startingServerId: 'v1',
      );
    });

    test('initial state should be empty', () {
      expect(provider.homeTeam, isNull);
      expect(provider.visitorTeam, isNull);
      expect(provider.rotations, isEmpty);
      expect(provider.currentRotationIndex, equals(0));
      expect(provider.currentRotation, isNull);
      expect(provider.hasValidRotations, isFalse);
    });

    test('setting single team should not generate rotations', () {
      provider.setHomeTeam(homeTeam);

      expect(provider.homeTeam, equals(homeTeam));
      expect(provider.rotations, isEmpty);
      expect(provider.hasValidRotations, isFalse);
    });

    test('setting both teams should generate rotations', () {
      provider.setHomeTeam(homeTeam);
      provider.setVisitorTeam(visitorTeam);

      expect(provider.rotations.length, equals(6));
      expect(provider.hasValidRotations, isTrue);
      expect(provider.currentRotation, isNotNull);
      expect(provider.currentRotation!.rotationNumber, equals(1));
    });

    test('navigation should work correctly', () {
      provider.setHomeTeam(homeTeam);
      provider.setVisitorTeam(visitorTeam);

      // Test next rotation
      provider.nextRotation();
      expect(provider.currentRotationIndex, equals(1));
      expect(provider.currentRotation!.rotationNumber, equals(2));

      // Test previous rotation
      provider.previousRotation();
      expect(provider.currentRotationIndex, equals(0));
      expect(provider.currentRotation!.rotationNumber, equals(1));

      // Test direct navigation
      provider.goToRotation(3);
      expect(provider.currentRotationIndex, equals(3));
      expect(provider.currentRotation!.rotationNumber, equals(4));
    });

    test('navigation should respect boundaries', () {
      provider.setHomeTeam(homeTeam);
      provider.setVisitorTeam(visitorTeam);

      // Try to go before first
      provider.previousRotation();
      expect(provider.currentRotationIndex, equals(0));

      // Go to last rotation
      provider.goToRotation(5);
      expect(provider.currentRotationIndex, equals(5));

      // Try to go past last
      provider.nextRotation();
      expect(provider.currentRotationIndex, equals(5));

      // Try invalid direct navigation
      provider.goToRotation(10);
      expect(provider.currentRotationIndex, equals(5)); // Should not change
    });

    test('handleServiceChange should update current rotation', () {
      provider.setHomeTeam(homeTeam);
      provider.setVisitorTeam(visitorTeam);

      final initialRotation = provider.currentRotation!;
      expect(initialRotation.homeTeamIsServing, isTrue);

      // Home team scores -> should not change service
      provider.handleServiceChange(true);
      expect(provider.currentRotation!.homeTeamIsServing, isTrue);

      // Visitor team scores -> should change service
      provider.handleServiceChange(false);
      expect(provider.currentRotation!.homeTeamIsServing, isFalse);
    });

    test('reset should clear all state', () {
      provider.setHomeTeam(homeTeam);
      provider.setVisitorTeam(visitorTeam);
      provider.goToRotation(3);

      provider.reset();

      expect(provider.homeTeam, isNull);
      expect(provider.visitorTeam, isNull);
      expect(provider.rotations, isEmpty);
      expect(provider.currentRotationIndex, equals(0));
      expect(provider.hasValidRotations, isFalse);
    });

    test('invalid team should not generate rotations', () {
      final invalidTeam = homeTeam.copyWith(
        players: homeTeam.players.take(4).toList(), // Only 4 players
      );

      provider.setHomeTeam(invalidTeam);
      provider.setVisitorTeam(visitorTeam);

      expect(provider.hasValidRotations, isFalse);
      expect(provider.validationErrors, isNotEmpty);
      expect(provider.isValid, isFalse);
    });

    test('validation errors should be properly reported', () {
      final invalidTeam = homeTeam.copyWith(
        players: homeTeam.players.take(4).toList(), // Only 4 players
      );

      provider.setHomeTeam(invalidTeam);

      final errors = provider.validationErrors;
      expect(errors, isNotEmpty);
      expect(errors.first, contains('Home Team:'));
      expect(errors.first, contains('exactly 6 players'));
    });

    test('should notify listeners on state changes', () {
      var notificationCount = 0;
      provider.addListener(() => notificationCount++);

      provider.setHomeTeam(homeTeam);
      expect(notificationCount, equals(1));

      provider.setVisitorTeam(visitorTeam);
      expect(notificationCount, equals(2));

      provider.nextRotation();
      expect(notificationCount, equals(3));

      provider.handleServiceChange(false);
      expect(notificationCount, equals(4));

      provider.reset();
      expect(notificationCount, equals(5));
    });
  });
}