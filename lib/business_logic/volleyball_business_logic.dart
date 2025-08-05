/// Volleyball Business Logic Library
/// 
/// This library provides all the business logic components for volleyball
/// rotation management, based on the insights from Volleyball-Simplified.
/// 
/// Key Features:
/// - Clockwise rotation algorithm following volleyball rules
/// - Service change logic (rotation only when gaining serve)
/// - Libero management (back row only)
/// - Team validation and position management
/// - Reactive state management with Provider pattern

library volleyball_business_logic;

// Models
export 'models/position.dart';
export 'models/player.dart';
export 'models/team.dart';
export 'models/court_state.dart';

// Services
export 'services/rotation_engine.dart';

// Providers
export 'providers/rotation_provider.dart';