---
created: 2025-08-22T20:18:02Z
last_updated: 2025-08-22T20:18:02Z
version: 1.0
author: Claude Code PM System
---

# System Patterns and Architecture

## Architectural Design Patterns

### Clean Architecture Implementation

The application follows Uncle Bob's Clean Architecture principles with clear layer separation:

```
┌─────────────────┬─────────────────┬─────────────────┐
│   Presentation  │  Infrastructure │    External     │
│     Layer       │     Layer       │   Interfaces    │
├─────────────────┼─────────────────┼─────────────────┤
│ UI Components   │ Providers       │ SharedPrefs     │
│ Main Menu       │ Persistence     │ Platform APIs   │
│ Court Painter   │ Services        │                 │
└─────────────────┴─────────────────┴─────────────────┘
                  │                 │
┌─────────────────┼─────────────────┼─────────────────┐
│              Application Layer                      │
├─────────────────┼─────────────────┼─────────────────┤
│ Business Logic  │ Use Cases       │ State Mgmt      │
│ Rotation Engine │ Team Management │ Data Flow       │
│ Validation      │ Player Tracking │                 │
└─────────────────┴─────────────────┴─────────────────┘
                  │
┌─────────────────┼─────────────────┬─────────────────┐
│               Domain Layer                          │
├─────────────────┼─────────────────┼─────────────────┤
│ Entities        │ Value Objects   │ Domain Rules    │
│ Team            │ Position        │ Rotation Logic  │
│ Player          │ CourtState      │ Validation      │
└─────────────────┴─────────────────┴─────────────────┘
```

### Key Architectural Principles

1. **Dependency Inversion:** Higher-level modules don't depend on lower-level modules
2. **Separation of Concerns:** Each layer has a single, well-defined responsibility
3. **Immutability:** State objects are immutable with `copyWith` methods
4. **Single Source of Truth:** Provider manages all application state

## State Management Patterns

### Provider Pattern Implementation

```dart
// State Management Architecture
Provider<T>                    // Dependency injection
ChangeNotifier                 // Observable state objects
Consumer<T>                    // Reactive UI components
Selector<T, R>                // Optimized rebuilds
ProxyProvider                  // Dependent providers
```

### State Flow Pattern

```
User Action → Provider Method → Business Logic → New State → UI Update
     ↑                                                         ↓
     └─────────────── Reactive Update Loop ──────────────────┘
```

### Immutable State Pattern

```dart
// All state objects follow this pattern:
class TeamState with EquatableMixin {
  final List<Player> players;
  final int currentRotation;
  
  const TeamState({
    required this.players,
    this.currentRotation = 0,
  });
  
  TeamState copyWith({
    List<Player>? players,
    int? currentRotation,
  }) {
    return TeamState(
      players: players ?? this.players,
      currentRotation: currentRotation ?? this.currentRotation,
    );
  }
  
  @override
  List<Object?> get props => [players, currentRotation];
}
```

## Data Flow Patterns

### Unidirectional Data Flow

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  UI Actions  │───▶│   Provider   │───▶│   Business   │
│              │    │              │    │    Logic     │
└──────────────┘    └──────────────┘    └──────────────┘
        ▲                   │                   │
        │                   ▼                   ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ UI Updates   │◀───│  New State   │◀───│  Domain      │
│              │    │              │    │  Operations  │
└──────────────┘    └──────────────┘    └──────────────┘
```

### Event-Driven Pattern

```dart
// User interactions trigger domain events
onPlayerPositionChanged(Player player, Position newPosition) {
  // 1. Validate the move
  if (!rotationEngine.isValidPosition(player, newPosition)) return;
  
  // 2. Apply business rules
  final updatedTeam = team.movePlayer(player, newPosition);
  
  // 3. Update state
  emit(state.copyWith(team: updatedTeam));
  
  // 4. Persist changes
  persistenceService.saveTeam(updatedTeam);
}
```

## Domain Modeling Patterns

### Entity Pattern

```dart
// Rich domain entities with behavior
class Team extends Equatable {
  final String id;
  final String name;
  final List<Player> players;
  final Player? libero;
  
  // Domain methods
  bool get isValidLineup => players.length == 6 && hasValidPositions();
  Team rotateClockwise() => /* rotation logic */;
  Team substituteLibero(Player backRowPlayer) => /* substitution logic */;
}
```

### Value Object Pattern

```dart
// Immutable value objects for domain concepts
enum VolleyballPosition {
  position1, position2, position3, // Front row
  position4, position5, position6; // Back row
  
  bool get isFrontRow => index < 3;
  bool get isBackRow => !isFrontRow;
  VolleyballPosition get next => /* rotation logic */;
}
```

### Repository Pattern

```dart
// Abstract data access
abstract class TeamRepository {
  Future<Team?> getTeam(String id);
  Future<void> saveTeam(Team team);
  Future<List<Team>> getAllTeams();
}

// Concrete implementation
class SharedPreferencesTeamRepository implements TeamRepository {
  // Implementation details
}
```

## UI Design Patterns

### Custom Painter Pattern

```dart
class VolleyballCourtPainter extends CustomPainter {
  final CourtState courtState;
  
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw court boundaries
    _drawCourtBoundaries(canvas, size);
    
    // 2. Draw attack lines
    _drawAttackLines(canvas, size);
    
    // 3. Draw player positions
    _drawPlayerPositions(canvas, size, courtState.players);
  }
  
  @override
  bool shouldRepaint(VolleyballCourtPainter oldDelegate) {
    return courtState != oldDelegate.courtState;
  }
}
```

### Composite Widget Pattern

```dart
class VolleyballField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RotationProvider>(
      builder: (context, provider, child) {
        return CustomPaint(
          painter: VolleyballCourtPainter(provider.courtState),
          child: GestureDetector(
            onTapDown: (details) => _handleCourtTap(details, provider),
            child: Container(/* court container */),
          ),
        );
      },
    );
  }
}
```

## Persistence Patterns

### Strategy Pattern for Data Storage

```dart
abstract class PersistenceStrategy {
  Future<String?> get(String key);
  Future<void> set(String key, String value);
}

class SharedPreferencesPersistence implements PersistenceStrategy {
  // SharedPreferences implementation
}

class PersistenceService {
  final PersistenceStrategy _strategy;
  
  PersistenceService(this._strategy);
  
  Future<Team?> loadTeam(String teamId) async {
    final json = await _strategy.get('team_$teamId');
    return json != null ? Team.fromJson(jsonDecode(json)) : null;
  }
}
```

### Serialization Pattern

```dart
// Consistent JSON serialization across all entities
mixin JsonSerializable {
  Map<String, dynamic> toJson();
  
  static T fromJson<T>(Map<String, dynamic> json, T Function(Map<String, dynamic>) constructor) {
    return constructor(json);
  }
}

class Player with EquatableMixin, JsonSerializable {
  // Implementation with toJson/fromJson
}
```

## Error Handling Patterns

### Result Pattern

```dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Failure<T> extends Result<T> {
  final String message;
  const Failure(this.message);
}

// Usage in business logic
Result<Team> validateTeamLineup(Team team) {
  if (team.players.length != 6) {
    return const Failure('Team must have exactly 6 players');
  }
  return Success(team);
}
```

### Exception Boundary Pattern

```dart
class ErrorHandler {
  static void handle(Object error, StackTrace stackTrace) {
    // Log error
    debugPrint('Error: $error\nStackTrace: $stackTrace');
    
    // Show user-friendly message
    // Navigate to error page if critical
  }
}

// Used in providers
try {
  final result = await businessLogicOperation();
  emit(SuccessState(result));
} catch (error, stackTrace) {
  ErrorHandler.handle(error, stackTrace);
  emit(ErrorState('Operation failed'));
}
```

## Testing Patterns

### Arrange-Act-Assert Pattern

```dart
group('RotationEngine', () {
  test('should rotate team clockwise correctly', () {
    // Arrange
    final team = Team.create([
      Player(id: '1', number: 1, position: VolleyballPosition.position1),
      // ... more players
    ]);
    final engine = RotationEngine();
    
    // Act
    final rotatedTeam = engine.rotateClockwise(team);
    
    // Assert
    expect(rotatedTeam.players[0].position, VolleyballPosition.position2);
    expect(rotatedTeam.players[1].position, VolleyballPosition.position3);
  });
});
```

### Mock Pattern for Testing

```dart
class MockPersistenceService extends Mock implements PersistenceService {}

void main() {
  group('TeamProvider', () {
    late MockPersistenceService mockPersistence;
    late TeamProvider provider;
    
    setUp(() {
      mockPersistence = MockPersistenceService();
      provider = TeamProvider(mockPersistence);
    });
    
    test('should save team when modified', () async {
      // Test implementation
    });
  });
}
```

## Validation Patterns

### Specification Pattern

```dart
abstract class Specification<T> {
  bool isSatisfiedBy(T candidate);
  String get errorMessage;
}

class ValidTeamLineupSpecification implements Specification<Team> {
  @override
  bool isSatisfiedBy(Team team) {
    return team.players.length == 6 && 
           team.hasUniquePositions() && 
           team.hasValidPlayerNumbers();
  }
  
  @override
  String get errorMessage => 'Team lineup is invalid';
}
```

### Builder Pattern for Complex Objects

```dart
class TeamBuilder {
  List<Player> _players = [];
  Player? _libero;
  String? _name;
  
  TeamBuilder addPlayer(Player player) {
    _players.add(player);
    return this;
  }
  
  TeamBuilder setLibero(Player libero) {
    _libero = libero;
    return this;
  }
  
  Team build() {
    if (_players.length != 6) {
      throw ArgumentError('Team must have exactly 6 players');
    }
    return Team(
      players: List.unmodifiable(_players),
      libero: _libero,
      name: _name ?? 'Unnamed Team',
    );
  }
}
```

These patterns work together to create a maintainable, testable, and scalable Flutter application that follows industry best practices while being AI-development friendly.