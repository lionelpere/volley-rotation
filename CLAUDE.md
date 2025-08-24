# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> Think carefully and implement the most concise solution that changes as little code as possible.

## Project Overview

This is a Flutter volleyball rotation tracker application that manages team rotations with a 6-player + libero system. The app features a realistic 9x9 volleyball court visualization and comprehensive rotation management.

## Architecture

### Directory Structure
```
lib/
├── business_logic/           # Clean architecture - domain layer
│   ├── models/              # Data models (Player, Team, Position, CourtState)
│   ├── providers/           # State management (RotationProvider)
│   ├── services/            # Business logic (RotationEngine)
│   └── volleyball_business_logic.dart  # Barrel exports
├── main.dart               # Entry point with Provider setup
├── main_menu.dart          # Main navigation
├── persistence_service.dart # Data storage with SharedPreferences
└── [UI components]         # Court visualization and interaction
```

### Key Patterns
- **Clean Architecture**: Business logic separated from UI in `business_logic/` directory
- **Provider Pattern**: State management with ChangeNotifier for reactive UI updates
- **Barrel Exports**: Use `volleyball_business_logic.dart` for clean imports
- **Custom Painters**: Volleyball court rendering with precise measurements

### State Management
- **New Architecture**: Provider-based state management in `business_logic/providers/`
- **Legacy Code**: `team_state.dart` and `rotation_model.dart` - consider consolidation
- **Persistence**: SharedPreferences via `persistence_service.dart`

## Development Commands

### Essential Commands
```bash
# Install dependencies
flutter pub get

# Run on web (primary platform)
flutter run -d chrome

# Run tests
flutter test

# Run specific test file
flutter test test/path/to/test_file.dart

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Check for outdated dependencies
flutter pub outdated
```

### Testing
```bash
# Run all tests with verbose output
flutter test --reporter expanded

# Run business logic tests only
flutter test test/business_logic/

# Run widget tests
flutter test test/ --name="widget"
```

## USE SUB-AGENTS FOR CONTEXT OPTIMIZATION

### 1. Always use the file-analyzer sub-agent when asked to read files.
The file-analyzer agent is an expert in extracting and summarizing critical information from files, particularly log files and verbose outputs. It provides concise, actionable summaries that preserve essential information while dramatically reducing context usage.

### 2. Always use the code-analyzer sub-agent when asked to search code, analyze code, research bugs, or trace logic flow.
The code-analyzer agent is an expert in code analysis, logic tracing, and vulnerability detection. It provides concise, actionable summaries that preserve essential information while dramatically reducing context usage.

### 3. Always use the test-runner sub-agent to run tests and analyze the test results.
Using the test-runner agent ensures:
- Full test output is captured for debugging
- Main conversation stays clean and focused
- Context usage is optimized
- All issues are properly surfaced
- No approval dialogs interrupt the workflow

## Development Guidelines

### Code Organization
- Import business logic via barrel export: `import 'business_logic/volleyball_business_logic.dart';`
- Follow existing naming patterns: `RotationProvider`, `VolleyballPosition`, etc.
- Place new models in `business_logic/models/`
- Place new services in `business_logic/services/`
- Place new providers in `business_logic/providers/`

### Flutter-Specific Rules
- Use `ChangeNotifier` for state management providers
- Implement proper `dispose()` methods for controllers and providers
- Use `Consumer<T>` or `context.watch<T>()` for reactive UI updates
- Follow Material Design principles for UI components

### Testing Strategy
- Always use the test-runner agent to execute tests
- Do not use mock services for anything ever
- Do not move on to the next test until the current test is complete
- If the test fails, consider checking if the test is structured correctly before deciding we need to refactor the codebase
- Tests to be verbose so we can use them for debugging
- Mirror `lib/` structure in `test/` directory
- Test business logic comprehensively in `test/business_logic/`

## Tone and Behavior

- Criticism is welcome. Please tell me when I am wrong or mistaken, or even when you think I might be wrong or mistaken.
- Please tell me if there is a better approach than the one I am taking.
- Please tell me if there is a relevant standard or convention that I appear to be unaware of.
- Be skeptical.
- Be concise.
- Short summaries are OK, but don't give an extended breakdown unless we are working through the details of a plan.
- Do not flatter, and do not give compliments unless I am specifically asking for your judgement.
- Occasional pleasantries are fine.
- Feel free to ask many questions. If you are in doubt of my intent, don't guess. Ask.

## ABSOLUTE RULES:

- NO PARTIAL IMPLEMENTATION
- NO SIMPLIFICATION : no "//This is simplified stuff for now, complete implementation would blablabla"
- NO CODE DUPLICATION : check existing codebase to reuse functions and constants Read files before writing new functions. Use common sense function name to find them easily.
- NO DEAD CODE : either use or delete from codebase completely
- IMPLEMENT TEST FOR EVERY FUNCTIONS
- NO CHEATER TESTS : test must be accurate, reflect real usage and be designed to reveal flaws. No useless tests! Design tests to be verbose so we can use them for debuging.
- NO INCONSISTENT NAMING - read existing codebase naming patterns.
- NO OVER-ENGINEERING - Don't add unnecessary abstractions, factory patterns, or middleware when simple functions would work. Don't think "enterprise" when you need "working"
- NO MIXED CONCERNS - Don't put validation logic inside API handlers, database queries inside UI components, etc. instead of proper separation
- NO RESOURCE LEAKS - Don't forget to close database connections, clear timeouts, remove event listeners, or clean up file handles
