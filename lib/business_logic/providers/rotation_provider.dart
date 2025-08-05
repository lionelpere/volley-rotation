import 'package:flutter/foundation.dart';
import '../models/team.dart';
import '../models/court_state.dart';
import '../models/position.dart';
import '../services/rotation_engine.dart';

/// Provider for managing rotation state in the application
/// 
/// This provider integrates the RotationEngine with Flutter's state management
/// to provide reactive updates when rotations change.
class RotationProvider extends ChangeNotifier {
  Team? _homeTeam;
  Team? _visitorTeam;
  List<CourtState> _rotations = [];
  int _currentRotationIndex = 0;

  // Getters
  Team? get homeTeam => _homeTeam;
  Team? get visitorTeam => _visitorTeam;
  List<CourtState> get rotations => List.unmodifiable(_rotations);
  int get currentRotationIndex => _currentRotationIndex;
  CourtState? get currentRotation => 
    _rotations.isNotEmpty ? _rotations[_currentRotationIndex] : null;
  bool get hasValidRotations => _rotations.isNotEmpty;

  /// Updates the home team and regenerates rotations if both teams are set
  void setHomeTeam(Team team) {
    _homeTeam = team;
    _regenerateRotationsIfReady();
    notifyListeners();
  }

  /// Updates the visitor team and regenerates rotations if both teams are set
  void setVisitorTeam(Team team) {
    _visitorTeam = team;
    _regenerateRotationsIfReady();
    notifyListeners();
  }

  /// Navigates to a specific rotation by index
  void goToRotation(int index) {
    if (index >= 0 && index < _rotations.length) {
      _currentRotationIndex = index;
      notifyListeners();
    }
  }

  /// Navigates to the next rotation
  void nextRotation() {
    if (_currentRotationIndex < _rotations.length - 1) {
      _currentRotationIndex++;
      notifyListeners();
    }
  }

  /// Navigates to the previous rotation
  void previousRotation() {
    if (_currentRotationIndex > 0) {
      _currentRotationIndex--;
      notifyListeners();
    }
  }

  /// Handles service change and updates current rotation
  void handleServiceChange(bool homeTeamScored) {
    if (currentRotation != null) {
      final newState = RotationEngine.handleServiceChange(
        currentRotation!,
        homeTeamScored,
      );
      
      // Update the current rotation in the list
      _rotations[_currentRotationIndex] = newState;
      notifyListeners();
    }
  }

  /// Resets to initial state
  void reset() {
    _homeTeam = null;
    _visitorTeam = null;
    _rotations.clear();
    _currentRotationIndex = 0;
    notifyListeners();
  }

  /// Regenerates rotations if both teams are available and valid
  void _regenerateRotationsIfReady() {
    if (_homeTeam != null && _visitorTeam != null) {
      if (_homeTeam!.isValid && _visitorTeam!.isValid) {
        try {
          _rotations = RotationEngine.generateAllRotations(
            homeTeam: _homeTeam!,
            visitorTeam: _visitorTeam!,
            homeTeamStartsServing: true,
          );
          _currentRotationIndex = 0;
        } catch (e) {
          // Handle invalid team configurations
          _rotations.clear();
          debugPrint('Failed to generate rotations: $e');
        }
      } else {
        _rotations.clear();
      }
    }
  }

  /// Gets validation errors for current teams
  List<String> get validationErrors {
    final errors = <String>[];
    
    if (_homeTeam != null) {
      errors.addAll(_homeTeam!.validationErrors.map((e) => 'Home Team: $e'));
    }
    
    if (_visitorTeam != null) {
      errors.addAll(_visitorTeam!.validationErrors.map((e) => 'Visitor Team: $e'));
    }
    
    return errors;
  }

  /// Checks if the current configuration is valid
  bool get isValid => validationErrors.isEmpty && hasValidRotations;

  /// Sets the current rotation directly (for initialization)
  void setCurrentRotation(CourtState rotation) {
    _rotations = [rotation];
    _currentRotationIndex = 0;
    notifyListeners();
  }

  /// Updates a player at a specific position
  void updatePlayerAtPosition(Position position, String playerId) {
    if (currentRotation != null) {
      final updatedPositions = Map<Position, String>.from(currentRotation!.homeTeamPositions);
      updatedPositions[position] = playerId;
      
      final updatedRotation = currentRotation!.copyWith(
        homeTeamPositions: updatedPositions,
      );
      
      _rotations[_currentRotationIndex] = updatedRotation;
      notifyListeners();
    }
  }

  /// Rotates the team clockwise
  void rotateClockwise() {
    if (currentRotation != null) {
      final rotatedPositions = RotationEngine.rotateClockwise(currentRotation!.homeTeamPositions);
      final updatedRotation = currentRotation!.copyWith(
        homeTeamPositions: rotatedPositions,
        rotationNumber: currentRotation!.rotationNumber + 1,
      );
      
      _rotations[_currentRotationIndex] = updatedRotation;
      notifyListeners();
    }
  }

  /// Toggles libero substitution
  void toggleLiberoSubstitution() {
    if (currentRotation != null) {
      final currentLiberoState = currentRotation!.homeLiberoState;
      LiberoState newLiberoState;
      
      switch (currentLiberoState) {
        case LiberoState.offCourt:
          newLiberoState = LiberoState.onCourt;
          break;
        case LiberoState.onCourt:
          newLiberoState = LiberoState.offCourt;
          break;
        case LiberoState.rotating:
          newLiberoState = LiberoState.onCourt;
          break;
      }
      
      final updatedRotation = currentRotation!.copyWith(
        homeLiberoState: newLiberoState,
      );
      
      _rotations[_currentRotationIndex] = updatedRotation;
      notifyListeners();
    }
  }
}