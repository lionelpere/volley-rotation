import '../models/position.dart';
import '../models/team.dart';
import '../models/court_state.dart';

/// Core rotation engine based on Volleyball-Simplified logic
/// 
/// This service handles the core business logic for volleyball rotations:
/// - Clockwise rotation when team gains serve
/// - Libero management (back row only)
/// - Position validation
/// - Service change logic
class RotationEngine {
  /// Generates all 6 possible rotations for both teams
  /// 
  /// Based on the algorithm from Volleyball-Simplified where:
  /// - Rotation is clockwise: P1->P2->P3->P4->P5->P6->P1
  /// - Each team starts with a designated server in P1
  /// - All 6 rotations are pre-calculated for strategy visualization
  static List<CourtState> generateAllRotations({
    required Team homeTeam,
    required Team visitorTeam,
    bool homeTeamStartsServing = true,
  }) {
    if (!homeTeam.isValid) {
      throw ArgumentError('Home team configuration is invalid: ${homeTeam.validationErrors.join(', ')}');
    }
    if (!visitorTeam.isValid) {
      throw ArgumentError('Visitor team configuration is invalid: ${visitorTeam.validationErrors.join(', ')}');
    }

    final rotations = <CourtState>[];
    
    // Start with initial positions
    var homePositions = Map<Position, String>.from(homeTeam.initialPositions);
    var visitorPositions = Map<Position, String>.from(visitorTeam.initialPositions);

    // Generate all 6 rotations
    for (int i = 0; i < 6; i++) {
      rotations.add(CourtState(
        rotationNumber: i + 1,
        homeTeamPositions: Map.from(homePositions),
        visitorTeamPositions: Map.from(visitorPositions),
        homeTeamIsServing: homeTeamStartsServing,
        homeLiberoState: _calculateLiberoState(homePositions, homeTeam),
        visitorLiberoState: _calculateLiberoState(visitorPositions, visitorTeam),
      ));

      // Rotate for next iteration (simulate gaining serve)
      homePositions = rotateClockwise(homePositions);
      visitorPositions = rotateClockwise(visitorPositions);
    }

    return rotations;
  }

  /// Performs clockwise rotation based on Volleyball-Simplified algorithm
  /// 
  /// JavaScript equivalent:
  /// ```javascript
  /// function rotateTeamClockwise() {
  ///   setTeamPlayers(prev => {
  ///     const arr = [...prev];
  ///     const last = arr.pop();      // Take last player
  ///     arr.unshift(last);           // Move to first position
  ///     return arr;
  ///   });
  /// }
  /// ```
  static Map<Position, String> rotateClockwise(Map<Position, String> positions) {
    // Extract players in rotation order
    final playerIds = Position.rotationOrder.map((pos) => positions[pos]!).toList();
    
    // Clockwise rotation: last element -> first element
    final lastPlayer = playerIds.removeLast();
    playerIds.insert(0, lastPlayer);
    
    // Rebuild position map
    final rotated = <Position, String>{};
    for (int i = 0; i < Position.rotationOrder.length; i++) {
      rotated[Position.rotationOrder[i]] = playerIds[i];
    }
    
    return rotated;
  }

  /// Handles service change and rotation logic from Volleyball-Simplified
  /// 
  /// Rules:
  /// - If serving team scores: no rotation, just score increment
  /// - If receiving team scores: they gain serve AND rotate
  static CourtState handleServiceChange(
    CourtState currentState,
    bool homeTeamScored,
  ) {
    if (currentState.homeTeamIsServing && homeTeamScored) {
      // Home team was serving and scored -> no rotation
      return currentState;
    } else if (!currentState.homeTeamIsServing && !homeTeamScored) {
      // Visitor team was serving and scored -> no rotation
      return currentState;
    } else {
      // Service change -> team gaining serve rotates
      return currentState.copyWith(
        homeTeamIsServing: homeTeamScored,
        homeTeamPositions: homeTeamScored 
          ? rotateClockwise(currentState.homeTeamPositions)
          : currentState.homeTeamPositions,
        visitorTeamPositions: !homeTeamScored
          ? rotateClockwise(currentState.visitorTeamPositions)
          : currentState.visitorTeamPositions,
      );
    }
  }

  /// Calculates libero state based on current position
  /// 
  /// Libero rules:
  /// - Can only play in back row (P1, P5, P6)
  /// - Automatically enters/exits based on rotation
  /// - Does not count as substitution
  static LiberoState _calculateLiberoState(Map<Position, String> positions, Team team) {
    final libero = team.libero;
    if (libero == null) return LiberoState.offCourt;

    // Check if libero is currently in back row
    final backRowPositions = [Position.p1, Position.p5, Position.p6];
    final isInBackRow = backRowPositions.any((pos) => positions[pos] == libero.id);

    return isInBackRow ? LiberoState.onCourt : LiberoState.offCourt;
  }

  /// Validates a team's rotation setup
  static List<String> validateRotationSetup(Team team) {
    final errors = <String>[];
    
    // Basic team validation
    errors.addAll(team.validationErrors);
    
    // Rotation-specific validations
    if (!team.initialPositions.containsKey(Position.p1)) {
      errors.add('P1 (server) position must be assigned');
    }
    
    // Validate libero replacement logic
    final libero = team.libero;
    if (libero != null && libero.liberoReplacesPlayerId != null) {
      final replacedPlayer = team.getPlayerById(libero.liberoReplacesPlayerId!);
      if (replacedPlayer == null) {
        errors.add('Libero replacement player ID is invalid');
      }
    }
    
    return errors;
  }

  /// Gets the rotation number where a specific player serves
  static int? getRotationNumberForServer(List<CourtState> rotations, String playerId) {
    for (final rotation in rotations) {
      if (rotation.servingPlayerId == playerId) {
        return rotation.rotationNumber;
      }
    }
    return null;
  }

  /// Gets all net confrontations (front row matchups) for a rotation
  static Map<Position, Map<String, String>> getNetConfrontations(CourtState state) {
    final confrontations = <Position, Map<String, String>>{};
    
    for (final frontRowPosition in [Position.p2, Position.p3, Position.p4]) {
      confrontations[frontRowPosition] = {
        'home': state.homeTeamPositions[frontRowPosition]!,
        'visitor': state.visitorTeamPositions[frontRowPosition]!,
      };
    }
    
    return confrontations;
  }

  /// Gets the receiving formation (back row players) for the non-serving team
  static Map<Position, String> getReceivingFormation(CourtState state) {
    return state.homeTeamIsServing 
      ? state.visitorTeamBackRowPositions
      : state.homeTeamBackRowPositions;
  }
}