import 'package:flutter_test/flutter_test.dart';
import 'package:volley_rotation/business_logic/models/position.dart';
import 'package:volley_rotation/business_logic/models/player.dart';
import 'package:volley_rotation/business_logic/models/team.dart';
import 'package:volley_rotation/business_logic/models/court_state.dart';
import 'package:volley_rotation/business_logic/services/rotation_engine.dart';

void main() {
  group('RotationEngine', () {
    late Team homeTeam;
    late Team visitorTeam;
    late List<Player> homePlayers;
    late List<Player> visitorPlayers;

    setUp(() {
      // Create test players
      homePlayers = [
        const Player(id: 'h1', jerseyNumber: 1, role: PlayerRole.setter),
        const Player(id: 'h2', jerseyNumber: 2, role: PlayerRole.outsideHitter),
        const Player(id: 'h3', jerseyNumber: 3, role: PlayerRole.middleBlocker),
        const Player(id: 'h4', jerseyNumber: 4, role: PlayerRole.outsideHitter),
        const Player(id: 'h5', jerseyNumber: 5, role: PlayerRole.oppositeHitter),
        const Player(id: 'h6', jerseyNumber: 6, role: PlayerRole.defensiveSpecialist),
      ];

      visitorPlayers = [
        const Player(id: 'v1', jerseyNumber: 11, role: PlayerRole.setter),
        const Player(id: 'v2', jerseyNumber: 12, role: PlayerRole.outsideHitter),
        const Player(id: 'v3', jerseyNumber: 13, role: PlayerRole.middleBlocker),
        const Player(id: 'v4', jerseyNumber: 14, role: PlayerRole.outsideHitter),
        const Player(id: 'v5', jerseyNumber: 15, role: PlayerRole.oppositeHitter),
        const Player(id: 'v6', jerseyNumber: 16, role: PlayerRole.defensiveSpecialist),
      ];

      // Create test teams with initial positions
      homeTeam = Team(
        id: 'home',
        name: 'Home Team',
        players: homePlayers,
        initialPositions: {
          Position.p1: 'h1', // Setter serves first
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

    group('rotateClockwise', () {
      test('should rotate positions clockwise correctly', () {
        final initialPositions = {
          Position.p1: 'A',
          Position.p2: 'B',
          Position.p3: 'C',
          Position.p4: 'D',
          Position.p5: 'E',
          Position.p6: 'F',
        };

        final rotated = RotationEngine.rotateClockwise(initialPositions);

        // After clockwise rotation: F->P1, A->P2, B->P3, C->P4, D->P5, E->P6
        expect(rotated[Position.p1], equals('F'));
        expect(rotated[Position.p2], equals('A'));
        expect(rotated[Position.p3], equals('B'));
        expect(rotated[Position.p4], equals('C'));
        expect(rotated[Position.p5], equals('D'));
        expect(rotated[Position.p6], equals('E'));
      });

      test('should maintain all players after rotation', () {
        final initialPositions = {
          Position.p1: 'h1',
          Position.p2: 'h2',
          Position.p3: 'h3',
          Position.p4: 'h4',
          Position.p5: 'h5',
          Position.p6: 'h6',
        };

        final rotated = RotationEngine.rotateClockwise(initialPositions);

        final initialPlayers = initialPositions.values.toSet();
        final rotatedPlayers = rotated.values.toSet();
        
        expect(rotatedPlayers, equals(initialPlayers));
        expect(rotated.length, equals(6));
      });
    });

    group('generateAllRotations', () {
      test('should generate 6 rotations', () {
        final rotations = RotationEngine.generateAllRotations(
          homeTeam: homeTeam,
          visitorTeam: visitorTeam,
        );

        expect(rotations.length, equals(6));
        
        for (int i = 0; i < 6; i++) {
          expect(rotations[i].rotationNumber, equals(i + 1));
        }
      });

      test('should have correct initial rotation', () {
        final rotations = RotationEngine.generateAllRotations(
          homeTeam: homeTeam,
          visitorTeam: visitorTeam,
        );

        final firstRotation = rotations[0];
        expect(firstRotation.homeTeamPositions[Position.p1], equals('h1'));
        expect(firstRotation.visitorTeamPositions[Position.p1], equals('v1'));
        expect(firstRotation.homeTeamIsServing, isTrue);
      });

      test('should have different positions for each rotation', () {
        final rotations = RotationEngine.generateAllRotations(
          homeTeam: homeTeam,
          visitorTeam: visitorTeam,
        );

        // Check that each rotation is different
        for (int i = 1; i < rotations.length; i++) {
          expect(
            rotations[i].homeTeamPositions,
            isNot(equals(rotations[i - 1].homeTeamPositions)),
          );
        }
      });

      test('should maintain all players across rotations', () {
        final rotations = RotationEngine.generateAllRotations(
          homeTeam: homeTeam,
          visitorTeam: visitorTeam,
        );

        final expectedHomePlayers = homePlayers.map((p) => p.id).toSet();
        final expectedVisitorPlayers = visitorPlayers.map((p) => p.id).toSet();

        for (final rotation in rotations) {
          final homePlayersInRotation = rotation.homeTeamPositions.values.toSet();
          final visitorPlayersInRotation = rotation.visitorTeamPositions.values.toSet();
          
          expect(homePlayersInRotation, equals(expectedHomePlayers));
          expect(visitorPlayersInRotation, equals(expectedVisitorPlayers));
        }
      });

      test('should throw error for invalid teams', () {
        final invalidTeam = homeTeam.copyWith(
          players: homePlayers.take(5).toList(), // Only 5 players
        );

        expect(
          () => RotationEngine.generateAllRotations(
            homeTeam: invalidTeam,
            visitorTeam: visitorTeam,
          ),
          throwsArgumentError,
        );
      });
    });

    group('handleServiceChange', () {
      late CourtState initialState;

      setUp(() {
        initialState = CourtState(
          rotationNumber: 1,
          homeTeamPositions: {
            Position.p1: 'h1',
            Position.p2: 'h2',
            Position.p3: 'h3',
            Position.p4: 'h4',
            Position.p5: 'h5',
            Position.p6: 'h6',
          },
          visitorTeamPositions: {
            Position.p1: 'v1',
            Position.p2: 'v2',
            Position.p3: 'v3',
            Position.p4: 'v4',
            Position.p5: 'v5',
            Position.p6: 'v6',
          },
          homeTeamIsServing: true,
        );
      });

      test('should not rotate when serving team scores', () {
        final newState = RotationEngine.handleServiceChange(initialState, true);

        // Home team was serving and scored -> no change
        expect(newState.homeTeamPositions, equals(initialState.homeTeamPositions));
        expect(newState.visitorTeamPositions, equals(initialState.visitorTeamPositions));
        expect(newState.homeTeamIsServing, isTrue);
      });

      test('should rotate and change serve when receiving team scores', () {
        final newState = RotationEngine.handleServiceChange(initialState, false);

        // Visitor team gains serve and rotates
        expect(newState.homeTeamIsServing, isFalse);
        expect(newState.homeTeamPositions, equals(initialState.homeTeamPositions)); // Home doesn't rotate
        expect(newState.visitorTeamPositions, isNot(equals(initialState.visitorTeamPositions))); // Visitor rotates
        
        // Check specific rotation
        expect(newState.visitorTeamPositions[Position.p1], equals('v6')); // Last player moves to P1
      });

      test('should handle visitor team serving scenario', () {
        final visitorServingState = initialState.copyWith(homeTeamIsServing: false);
        
        // Visitor serving, home scores
        final newState = RotationEngine.handleServiceChange(visitorServingState, true);
        
        expect(newState.homeTeamIsServing, isTrue);
        expect(newState.visitorTeamPositions, equals(visitorServingState.visitorTeamPositions)); // Visitor doesn't rotate
        expect(newState.homeTeamPositions, isNot(equals(visitorServingState.homeTeamPositions))); // Home rotates
      });
    });

    group('utility methods', () {
      test('getRotationNumberForServer should find correct rotation', () {
        final rotations = RotationEngine.generateAllRotations(
          homeTeam: homeTeam,
          visitorTeam: visitorTeam,
        );

        // Find which rotation h1 serves in
        final rotationNumber = RotationEngine.getRotationNumberForServer(rotations, 'h1');
        expect(rotationNumber, equals(1)); // Should be first rotation
      });

      test('getNetConfrontations should return front row matchups', () {
        final state = CourtState(
          rotationNumber: 1,
          homeTeamPositions: {
            Position.p1: 'h1', Position.p2: 'h2', Position.p3: 'h3',
            Position.p4: 'h4', Position.p5: 'h5', Position.p6: 'h6',
          },
          visitorTeamPositions: {
            Position.p1: 'v1', Position.p2: 'v2', Position.p3: 'v3',
            Position.p4: 'v4', Position.p5: 'v5', Position.p6: 'v6',
          },
          homeTeamIsServing: true,
        );

        final confrontations = RotationEngine.getNetConfrontations(state);

        expect(confrontations.length, equals(3));
        expect(confrontations[Position.p2]!['home'], equals('h2'));
        expect(confrontations[Position.p2]!['visitor'], equals('v2'));
        expect(confrontations[Position.p3]!['home'], equals('h3'));
        expect(confrontations[Position.p3]!['visitor'], equals('v3'));
        expect(confrontations[Position.p4]!['home'], equals('h4'));
        expect(confrontations[Position.p4]!['visitor'], equals('v4'));
      });

      test('getReceivingFormation should return back row of receiving team', () {
        final state = CourtState(
          rotationNumber: 1,
          homeTeamPositions: {
            Position.p1: 'h1', Position.p2: 'h2', Position.p3: 'h3',
            Position.p4: 'h4', Position.p5: 'h5', Position.p6: 'h6',
          },
          visitorTeamPositions: {
            Position.p1: 'v1', Position.p2: 'v2', Position.p3: 'v3',
            Position.p4: 'v4', Position.p5: 'v5', Position.p6: 'v6',
          },
          homeTeamIsServing: true,
        );

        final receivingFormation = RotationEngine.getReceivingFormation(state);

        // Home is serving, so visitor is receiving
        expect(receivingFormation.length, equals(3));
        expect(receivingFormation[Position.p1], equals('v1'));
        expect(receivingFormation[Position.p5], equals('v5'));
        expect(receivingFormation[Position.p6], equals('v6'));
      });
    });

    group('libero handling', () {
      test('should calculate libero state correctly', () {
        final libero = const Player(
          id: 'libero',
          jerseyNumber: 99,
          role: PlayerRole.libero,
          isLibero: true,
        );

        final teamWithLibero = homeTeam.copyWith(
          players: [...homePlayers.take(5), libero],
          initialPositions: {
            Position.p1: libero.id, // Libero in back row
            Position.p2: 'h2',
            Position.p3: 'h3',
            Position.p4: 'h4',
            Position.p5: 'h5',
            Position.p6: 'h1', // Use h1 instead of h6 since we only have 5 players + libero
          },
        );

        final rotations = RotationEngine.generateAllRotations(
          homeTeam: teamWithLibero,
          visitorTeam: visitorTeam,
        );

        // First rotation: libero in P1 (back row) -> should be on court
        expect(rotations[0].homeLiberoState, equals(LiberoState.onCourt));

        // Second rotation: libero rotates to P2 (front row) -> should be off court
        expect(rotations[1].homeLiberoState, equals(LiberoState.offCourt));
      });
    });
  });
}