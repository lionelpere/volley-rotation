---
created: 2025-08-22T20:18:02Z
last_updated: 2025-08-22T20:18:02Z
version: 1.0
author: Claude Code PM System
---

# Project Style Guide

## Code Standards and Conventions

### Dart/Flutter Coding Standards

#### File Naming Conventions
```dart
// Use snake_case for file names
models/
├── court_state.dart          ✅ Correct
├── volleyball_position.dart  ✅ Correct
├── CourtState.dart           ❌ Incorrect (PascalCase)
├── volleyball-position.dart  ❌ Incorrect (kebab-case)

// Barrel export files use domain prefix
volleyball_business_logic.dart ✅ Correct
business_logic.dart           ❌ Less descriptive
```

#### Class and Interface Naming
```dart
// Use PascalCase for classes, enums, and typedefs
class RotationProvider extends ChangeNotifier { }     ✅ Correct
class rotationProvider { }                            ❌ Incorrect

// Use descriptive, domain-specific names
class VolleyballPosition { }                          ✅ Correct
class Position { }                                    ❌ Too generic

// Prefix abstract classes with 'Abstract' or suffix with 'Base'
abstract class AbstractTeamRepository { }             ✅ Correct
abstract class TeamRepositoryBase { }                 ✅ Correct
abstract class TeamRepo { }                           ❌ Abbreviated
```

#### Variable and Method Naming
```dart
// Use camelCase for variables, methods, and parameters
final List<Player> activePlayerList;                  ✅ Correct
final currentRotationIndex;                           ✅ Correct
final List<Player> ActivePlayerList;                  ❌ Incorrect (PascalCase)

// Use descriptive names avoiding abbreviations
bool isValidRotation(Team team) { }                   ✅ Correct
bool isValidRot(Team t) { }                          ❌ Abbreviated

// Boolean variables should be questions
bool isLiberoOnCourt;                                 ✅ Correct
bool liberoStatus;                                    ❌ Not descriptive
```

#### Constant Naming
```dart
// Use SCREAMING_SNAKE_CASE for constants
const int MAX_PLAYERS_PER_TEAM = 6;                   ✅ Correct
const double COURT_WIDTH_METERS = 9.0;                ✅ Correct
const int maxPlayers = 6;                             ❌ Incorrect (camelCase)
```

### Project Structure Patterns

#### Directory Organization
```
lib/
├── business_logic/                    # Domain layer
│   ├── models/                       # Pure data models
│   ├── providers/                    # State management
│   ├── services/                     # Business logic
│   └── volleyball_business_logic.dart # Barrel export
├── main.dart                         # App entry point
├── main_menu.dart                    # Navigation
├── [feature]_[component].dart        # Feature-specific files
└── [shared]_[utility].dart           # Shared utilities
```

#### Import Organization
```dart
// Import order: Dart core, Flutter, packages, relative
import 'dart:math';                                   // Dart core libraries

import 'package:flutter/material.dart';               // Flutter framework
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';              // Third-party packages
import 'package:shared_preferences/shared_preferences.dart';

import 'business_logic/volleyball_business_logic.dart'; // Project imports
import 'persistence_service.dart';
```

### Architecture Patterns

#### Model Design Patterns
```dart
// All models extend Equatable for value equality
class Player extends Equatable {
  final String id;
  final int number;
  final VolleyballPosition position;
  
  const Player({
    required this.id,
    required this.number,
    required this.position,
  });
  
  // Immutable updates with copyWith
  Player copyWith({
    String? id,
    int? number,
    VolleyballPosition? position,
  }) {
    return Player(
      id: id ?? this.id,
      number: number ?? this.number,
      position: position ?? this.position,
    );
  }
  
  // JSON serialization
  Map<String, dynamic> toJson() => {
    'id': id,
    'number': number,
    'position': position.index,
  };
  
  factory Player.fromJson(Map<String, dynamic> json) => Player(
    id: json['id'] as String,
    number: json['number'] as int,
    position: VolleyballPosition.values[json['position'] as int],
  );
  
  // Equatable implementation
  @override
  List<Object?> get props => [id, number, position];
}
```

#### Provider Pattern Implementation
```dart
// Provider classes extend ChangeNotifier
class RotationProvider extends ChangeNotifier {
  Team _homeTeam;
  Team _visitorTeam;
  
  // Private state with public getters
  Team get homeTeam => _homeTeam;
  Team get visitorTeam => _visitorTeam;
  
  // Public methods for state changes
  void rotateHomeTeam() {
    _homeTeam = _rotationEngine.rotateClockwise(_homeTeam);
    notifyListeners();
    _persistenceService.saveHomeTeam(_homeTeam);
  }
  
  // Private helper methods
  void _validateTeamLineup(Team team) {
    // Validation logic
  }
}
```

#### Service Layer Pattern
```dart
// Services are stateless with clear responsibilities
class RotationEngine {
  // Static methods for pure business logic
  static Team rotateClockwise(Team team) {
    final rotatedPlayers = team.players.map((player) {
      final nextPosition = _getNextPosition(player.position);
      return player.copyWith(position: nextPosition);
    }).toList();
    
    return team.copyWith(players: rotatedPlayers);
  }
  
  // Private helper methods
  static VolleyballPosition _getNextPosition(VolleyballPosition current) {
    // Position calculation logic
  }
}
```

### UI/UX Design Patterns

#### Widget Organization
```dart
// Stateless widgets for presentation
class VolleyballField extends StatelessWidget {
  const VolleyballField({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<RotationProvider>(
      builder: (context, provider, child) {
        return CustomPaint(
          painter: VolleyballCourtPainter(provider.courtState),
          child: _buildInteractionLayer(provider),
        );
      },
    );
  }
  
  Widget _buildInteractionLayer(RotationProvider provider) {
    // Interaction handling
  }
}
```

#### Material Design Adherence
```dart
// Use Material Design components and patterns
AppBar(
  title: const Text('Volleyball Rotation Tracker'),
  backgroundColor: Theme.of(context).primaryColor,
  actions: [
    IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () => _openSettings(context),
    ),
  ],
)

// Consistent color scheme
ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.orange,
  // Volleyball-themed colors
)
```

### Testing Conventions

#### Test File Organization
```dart
// Test files mirror source structure with _test suffix
test/
├── business_logic/
│   ├── models/
│   │   ├── player_test.dart
│   │   └── team_test.dart
│   └── services/
│       └── rotation_engine_test.dart
└── widget_test.dart
```

#### Test Structure Pattern
```dart
// Use descriptive test groups and names
group('RotationEngine', () {
  group('rotateClockwise', () {
    test('should move all players to next position', () {
      // Arrange
      final team = TeamBuilder()
        .addPlayer(Player.create(1, VolleyballPosition.position1))
        .addPlayer(Player.create(2, VolleyballPosition.position2))
        .build();
      
      // Act
      final rotatedTeam = RotationEngine.rotateClockwise(team);
      
      // Assert
      expect(rotatedTeam.players[0].position, VolleyballPosition.position2);
      expect(rotatedTeam.players[1].position, VolleyballPosition.position3);
    });
    
    test('should handle position6 to position1 transition', () {
      // Test edge case
    });
  });
});
```

### Documentation Standards

#### Code Documentation
```dart
/// Manages volleyball team rotations and player positioning.
/// 
/// This provider handles all state changes related to team management,
/// including player rotations, libero substitutions, and position validation.
/// 
/// Example usage:
/// ```dart
/// final provider = Provider.of<RotationProvider>(context);
/// provider.rotateHomeTeam();
/// ```
class RotationProvider extends ChangeNotifier {
  
  /// Rotates the home team clockwise according to volleyball rules.
  /// 
  /// Each player moves to the next position in the rotation sequence:
  /// 1→2→3→4→5→6→1. The rotation is only allowed if it results in
  /// a valid formation according to volleyball positioning rules.
  /// 
  /// Throws [InvalidRotationException] if the rotation would result
  /// in an illegal formation.
  void rotateHomeTeam() {
    // Implementation
  }
}
```

#### README and Documentation Structure
```markdown
# Section Organization
## Quick Start
## Installation
## Usage Examples
## API Reference
## Contributing
## License

# Code Examples
Use executable code blocks with proper syntax highlighting
Use real examples from the codebase
Include expected output where relevant
```

### Git Commit Conventions

#### Commit Message Format
```bash
# Use conventional commit format
type(scope): description

# Examples:
feat(rotation): add libero substitution tracking
fix(ui): correct court dimensions on mobile
docs(readme): update installation instructions
test(models): add player validation tests
refactor(providers): simplify state management logic
```

#### Commit Types
- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `test`: Adding or modifying tests
- `refactor`: Code refactoring without behavior changes
- `style`: Code style changes (formatting, etc.)
- `chore`: Maintenance tasks

### Error Handling Patterns

#### Exception Handling
```dart
// Custom exceptions for domain errors
class InvalidRotationException implements Exception {
  final String message;
  const InvalidRotationException(this.message);
  
  @override
  String toString() => 'InvalidRotationException: $message';
}

// Consistent error handling in providers
void rotateTeam() {
  try {
    final rotatedTeam = _rotationEngine.rotateClockwise(_currentTeam);
    _updateTeam(rotatedTeam);
  } on InvalidRotationException catch (e) {
    _showUserError('Cannot rotate: ${e.message}');
  } catch (e) {
    _showUserError('Unexpected error occurred');
    _logError(e);
  }
}
```

### Performance Guidelines

#### Efficient State Management
```dart
// Use Selector for specific state slices
Selector<RotationProvider, List<Player>>(
  selector: (context, provider) => provider.homeTeam.players,
  builder: (context, players, child) {
    return PlayerList(players: players);
  },
)

// Avoid unnecessary rebuilds
Consumer<RotationProvider>(
  builder: (context, provider, child) {
    return ExpensiveWidget(
      data: provider.homeTeam,
      child: child, // Pass through unchanged child
    );
  },
  child: const StaticChildWidget(),
)
```

This style guide ensures consistent, maintainable, and professional code quality throughout the Volleyball Rotation Tracker project while following Flutter and Dart best practices.