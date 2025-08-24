---
created: 2025-08-22T20:18:02Z
last_updated: 2025-08-22T20:18:02Z
version: 1.0
author: Claude Code PM System
---

# Project Structure

## Root Directory Organization

```
volley-rotation/
├── .claude/                 # AI development tooling and workflows
├── .dart_tool/             # Dart/Flutter build cache
├── .git/                   # Git repository metadata
├── .github/                # GitHub Actions CI/CD workflows
├── .idea/                  # IntelliJ IDEA configuration
├── android/                # Android platform specific code
├── build/                  # Flutter build outputs
├── ios/                    # iOS platform specific code
├── lib/                    # Main Flutter source code
├── linux/                  # Linux platform specific code
├── macos/                  # macOS platform specific code
├── test/                   # Test suite
├── web/                    # Web platform specific code
├── windows/                # Windows platform specific code
├── volleyball_simplified_flutter/ # Alternative implementation
├── CLAUDE.md              # AI development guidelines
├── README.md              # Project documentation
├── pubspec.yaml           # Flutter project configuration
└── analysis_options.yaml # Dart linting configuration
```

## Core Source Structure (`lib/`)

### Clean Architecture Implementation
```
lib/
├── business_logic/                    # Domain Layer (Clean Architecture)
│   ├── models/                       # Core Domain Entities
│   │   ├── court_state.dart         # Volleyball court state representation
│   │   ├── player.dart              # Player entity with position/number
│   │   ├── team.dart                # Team entity with players and rotations
│   │   └── volleyball_position.dart # Position enumeration and logic
│   ├── providers/                    # State Management Layer
│   │   └── rotation_provider.dart   # Provider for rotation state management
│   ├── services/                     # Business Logic Services
│   │   └── rotation_engine.dart     # Core rotation calculation engine
│   └── volleyball_business_logic.dart # Barrel export for clean imports
├── main.dart                         # Application entry point
├── main_menu.dart                    # Primary navigation interface
├── persistence_service.dart          # Data persistence abstraction
├── realistic_volleyball_field.dart   # Custom court painter (9x9 grid)
├── rotation_model.dart              # Legacy rotation model
├── team_state.dart                  # Legacy state management
└── volleyball_field.dart            # Court UI component
```

### File Naming Patterns
- **Models:** `snake_case.dart` (e.g., `court_state.dart`, `volleyball_position.dart`)
- **Providers:** `*_provider.dart` (e.g., `rotation_provider.dart`)
- **Services:** `*_service.dart` or `*_engine.dart` (e.g., `persistence_service.dart`)
- **UI Components:** Descriptive names (e.g., `realistic_volleyball_field.dart`)
- **Barrel Exports:** Domain name + `_business_logic.dart`

## Test Structure (`test/`)

### Test Organization Mirrors Source
```
test/
├── business_logic/           # Business logic unit tests
│   ├── models/              # Model unit tests
│   │   ├── court_state_test.dart
│   │   ├── player_test.dart
│   │   ├── team_test.dart
│   │   └── volleyball_position_test.dart
│   ├── providers/           # Provider tests
│   │   └── rotation_provider_test.dart
│   └── services/            # Service layer tests
│       └── rotation_engine_test.dart
└── widget_test.dart         # Widget integration tests
```

### Test Naming Convention
- **Pattern:** `{source_file}_test.dart`
- **Location:** Mirrors source directory structure
- **Coverage:** All business logic components have corresponding tests

## Platform-Specific Directories

### Flutter Multi-Platform Structure
```
android/          # Android-specific configuration
├── app/
│   ├── src/main/
│   │   ├── AndroidManifest.xml
│   │   └── res/             # Android resources
│   └── build.gradle
└── gradle/                  # Gradle wrapper and configuration

ios/              # iOS-specific configuration
├── Runner/
│   ├── Info.plist
│   ├── Assets.xcassets/
│   └── Runner-Bridging-Header.h
└── Runner.xcodeproj/        # Xcode project

web/              # Web-specific configuration
├── index.html               # Web entry point
├── manifest.json           # PWA manifest
└── icons/                  # Web app icons

macos/            # macOS-specific configuration
├── Runner/
│   ├── Info.plist
│   ├── Assets.xcassets/
│   └── MainFlutterWindow.swift
└── Runner.xcodeproj/        # Xcode project for macOS

windows/          # Windows-specific configuration
├── runner/
│   ├── flutter_window.cpp
│   ├── main.cpp
│   └── resource.h
└── CMakeLists.txt           # CMake build configuration

linux/            # Linux-specific configuration
├── flutter/
│   └── generated_plugin_registrant.cc
├── main.cc
└── CMakeLists.txt           # CMake build configuration
```

## AI Development Infrastructure (`.claude/`)

### Claude Code Tooling Structure
```
.claude/
├── agents/                  # AI agent configurations
├── commands/                # Custom CLI commands
├── context/                 # Project context documentation
├── epics/                   # Feature epic documentation
├── prds/                    # Product requirement documents
├── rules/                   # Development rules and guidelines
├── scripts/                 # Automation scripts
│   ├── pm/                  # Project management scripts
│   └── test-and-log.sh      # Test execution script
└── settings.local.json      # Local Claude Code settings
```

## Configuration Files

### Primary Configuration
```
pubspec.yaml                 # Flutter project dependencies and metadata
analysis_options.yaml       # Dart linting rules and analysis configuration
.gitignore                   # Git ignore patterns
.metadata                    # Flutter project metadata
```

### Platform Configuration Files
```
android/app/build.gradle     # Android build configuration
ios/Runner/Info.plist        # iOS app configuration
web/manifest.json           # PWA configuration
macos/Runner/Info.plist     # macOS app configuration
windows/runner/resource.h    # Windows resource definitions
linux/CMakeLists.txt        # Linux build configuration
```

## Module Organization Patterns

### Business Logic Separation
- **Domain Models:** Pure Dart classes with no Flutter dependencies
- **Providers:** Flutter-specific state management with ChangeNotifier
- **Services:** Business logic implementation, testable in isolation
- **Barrel Exports:** Single import point for each domain area

### Import Patterns
```dart
// Barrel import for business logic
import 'business_logic/volleyball_business_logic.dart';

// Flutter framework imports
import 'package:flutter/material.dart';

// Third-party package imports
import 'package:provider/provider.dart';

// Relative imports for same-directory files
import 'main_menu.dart';
```

### State Management Architecture
- **Provider Pattern:** Primary state management approach
- **Immutable State:** All state objects use `copyWith` patterns
- **Reactive UI:** Components rebuild automatically via Provider consumers
- **Persistence Layer:** Automatic save/load with SharedPreferences

## Data Flow Architecture

### Layer Responsibilities
1. **Presentation Layer (`lib/*.dart`):** UI components, user interaction
2. **Provider Layer (`providers/`):** State management, UI binding
3. **Service Layer (`services/`):** Business logic, domain operations
4. **Model Layer (`models/`):** Data structures, domain entities
5. **Persistence Layer (`persistence_service.dart`):** Data storage/retrieval

### Communication Pattern
```
UI Components
    ↕ (Provider/Consumer)
Provider Layer
    ↕ (Method calls)
Service Layer
    ↕ (Domain operations)
Model Layer
    ↕ (Serialization)
Persistence Layer
```

This structure implements clean architecture principles with clear separation of concerns, comprehensive testing, and multi-platform support while maintaining AI-friendly development patterns.