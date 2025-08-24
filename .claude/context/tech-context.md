---
created: 2025-08-22T20:18:02Z
last_updated: 2025-08-22T20:18:02Z
version: 1.0
author: Claude Code PM System
---

# Technology Context

## Core Technology Stack

### Runtime Environment
- **Framework:** Flutter (Latest stable)
- **Language:** Dart SDK ^3.8.1
- **Minimum SDK:** Dart 3.8.1+
- **Target Platforms:** Web (primary), iOS, Android, macOS, Windows, Linux

### Development Tools
- **Package Manager:** pub (Dart/Flutter package manager)
- **Build System:** Flutter build system with platform-specific toolchains
- **Dependency Management:** pubspec.yaml with version constraints
- **Code Analysis:** flutter_lints ^5.0.0 for code quality enforcement

## Production Dependencies

### Core Framework
```yaml
flutter:
  sdk: flutter                    # Flutter framework (latest stable)
```

### UI and Design
```yaml
cupertino_icons: ^1.0.8          # iOS-style icons for cross-platform consistency
```

### State Management
```yaml
provider: ^6.1.2                 # Provider pattern for reactive state management
                                 # - ChangeNotifier implementation
                                 # - Consumer/Selector widgets
                                 # - Dependency injection
```

### Data Persistence
```yaml
shared_preferences: ^2.3.3       # Local key-value storage
                                 # - Cross-platform preferences
                                 # - Automatic platform mapping
                                 # - Supports all primitive types + String lists
```

### Utility Libraries
```yaml
equatable: ^2.0.5                # Value equality for immutable objects
                                 # - Simplifies comparison logic
                                 # - Reduces boilerplate for hashCode/==
                                 # - Essential for state management
```

## Development Dependencies

### Testing Framework
```yaml
flutter_test:
  sdk: flutter                   # Built-in Flutter testing framework
                                 # - Unit testing for business logic
                                 # - Widget testing for UI components
                                 # - Integration testing capabilities
```

### Code Quality
```yaml
flutter_lints: ^5.0.0           # Official Flutter linting rules
                                 # - Enforces Flutter best practices
                                 # - Dart language consistency
                                 # - Performance optimizations
                                 # - Accessibility guidelines
```

## Development Environment

### Required Tools
```bash
# Flutter SDK (latest stable)
flutter --version               # Verify Flutter installation

# Dart SDK (comes with Flutter)
dart --version                  # Verify Dart installation

# Platform-specific tools
# Web: Chrome browser for testing
# iOS: Xcode (macOS only)
# Android: Android Studio + SDK
# Desktop: Platform-specific build tools
```

### Development Commands
```bash
# Dependency management
flutter pub get                 # Install dependencies
flutter pub upgrade             # Update dependencies
flutter pub outdated            # Check for newer versions

# Development
flutter run -d chrome           # Run on web (primary platform)
flutter run -d ios             # Run on iOS simulator
flutter run -d android         # Run on Android emulator

# Testing
flutter test                    # Run all tests
flutter test --coverage        # Generate coverage report
flutter test test/business_logic/ # Run specific test directory

# Analysis and quality
flutter analyze                 # Run static analysis
flutter format lib/ test/      # Format code
```

## Platform-Specific Technologies

### Web Platform (Primary)
```yaml
# Configuration: web/index.html, web/manifest.json
# Features:
# - Progressive Web App (PWA) support
# - Custom app icons and theming
# - Offline capability
# - Responsive design
# - Direct deployment via GitHub Actions
```

### Mobile Platforms
```yaml
# iOS: ios/Runner/Info.plist
# - Native iOS integration
# - iOS-specific icons and launch screens
# - App Store deployment ready

# Android: android/app/build.gradle
# - Material Design integration
# - Android-specific icons and themes
# - Google Play Store deployment ready
```

### Desktop Platforms
```yaml
# macOS: macos/Runner/Info.plist
# - Native macOS app bundle
# - macOS-specific integrations

# Windows: windows/runner/main.cpp
# - Native Windows executable
# - Windows-specific configurations

# Linux: linux/main.cc
# - Native Linux application
# - GTK-based UI integration
```

## Architecture Technologies

### State Management Architecture
```dart
// Provider Pattern Implementation
ChangeNotifier                   # Base class for state objects
Consumer<T>                      # Reactive UI widgets
Provider.of<T>(context)         # State access pattern
MultiProvider                    # Multiple state providers
```

### Data Persistence Architecture
```dart
// SharedPreferences Implementation
SharedPreferences.getInstance()  # Platform-specific storage
JSON serialization              # Custom toJson/fromJson methods
String/Map<String,dynamic>      # Data format for persistence
```

### Custom Rendering
```dart
// CustomPainter for volleyball court
CustomPainter                   # Flutter custom graphics
Canvas API                      # Drawing operations
Paint objects                   # Styling and colors
Path operations                 # Complex shapes and lines
```

## Build and Deployment

### CI/CD Technology Stack
```yaml
# GitHub Actions
# - Workflow: .github/workflows/
# - Flutter installation and caching
# - Multi-platform builds
# - Automated testing
# - Web deployment via FTP

# Build Outputs
# - Web: build/web/ (deployable static files)
# - iOS: build/ios/ (Xcode archive)
# - Android: build/app/outputs/apk/
# - Desktop: build/{platform}/
```

### Deployment Targets
```yaml
Web:
  Primary: GitHub Actions → FTP deployment
  Alternative: Firebase Hosting, Netlify, Vercel

Mobile:
  iOS: App Store Connect (requires developer account)
  Android: Google Play Console (requires developer account)

Desktop:
  macOS: Direct distribution or Mac App Store
  Windows: Microsoft Store or direct distribution
  Linux: Package managers or direct distribution
```

## Development Workflow Technologies

### Version Control
```bash
Git                             # Version control system
GitHub                          # Repository hosting
GitHub Actions                  # CI/CD automation
```

### AI Development Tools
```yaml
Claude Code                     # AI-powered development environment
.claude/                        # Claude-specific configurations
AI Agents                       # Specialized AI assistants for different tasks
Project Management Scripts      # Automated PM workflows
```

### Code Quality Tools
```yaml
flutter_lints                   # Official linting rules
Dart analyzer                   # Static analysis tool
flutter format                  # Code formatting
flutter test --coverage        # Test coverage reporting
```

## Performance Considerations

### Flutter Performance Features
```dart
// Built-in optimizations
Widget recycling                # Automatic widget reuse
Tree shaking                    # Dead code elimination
Ahead-of-time compilation       # Optimized release builds
```

### Custom Optimizations
```dart
// Implemented patterns
Immutable state objects         # Reduced rebuilds
Provider.of listen: false       # One-time data access
Selective widget rebuilds       # Precise Consumer usage
Efficient CustomPainter         # Optimized court rendering
```

## Security Considerations

### Data Security
```yaml
# No external API dependencies
# - Zero network requests
# - No authentication required
# - All data stored locally
# - No sensitive information handling

# Local Storage Security
# - SharedPreferences encryption (platform-specific)
# - No credentials or tokens stored
# - User data remains on device
```

## Monitoring and Debugging

### Development Tools
```yaml
Flutter Inspector              # UI debugging and analysis
Dart DevTools                  # Performance profiling
Flutter logs                   # Runtime debugging
Hot reload/restart             # Rapid development iteration
```

### Error Handling
```dart
// Implemented patterns
try-catch blocks               # Exception handling
Null safety                    # Compile-time null protection
Validation methods             # Input sanitization
Graceful error states          # User-friendly error UI
```

This technology stack represents a modern, cross-platform Flutter application with minimal external dependencies, focusing on performance, maintainability, and AI-assisted development workflows.