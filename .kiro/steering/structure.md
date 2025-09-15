# Project Structure

## Root Directory Layout
```
my_app/
├── lib/                    # Main application code
├── android/               # Android platform files
├── ios/                   # iOS platform files  
├── web/                   # Web platform files
├── windows/               # Windows platform files
├── linux/                 # Linux platform files
├── macos/                 # macOS platform files
├── test/                  # Unit and widget tests
├── build/                 # Build outputs (generated)
├── .dart_tool/           # Dart tooling (generated)
└── pubspec.yaml          # Project dependencies
```

## lib/ Directory Structure
```
lib/
├── main.dart             # App entry point with theme setup
├── config/               # App configuration
├── constants/            # App-wide constants
├── models/               # Data models with JSON serialization
├── screens/              # UI screens and pages
├── services/             # Business logic and API integration
└── utils/                # Utility functions and helpers
```

## Key Directories

### `/lib/models/`
Data models representing app entities:
- `steps.dart` - Repair step model
- Follow pattern: simple classes with required/optional fields
- Use JSON serialization for API integration

### `/lib/services/`
Business logic and external integrations:
- `supabase_steps_service.dart` - Database operations
- `theme_service.dart` - Theme management
- `local_storage_service.dart` - Local data persistence
- Follow pattern: static methods for stateless operations, singleton for stateful services

### `/lib/screens/`
UI components and screens:
- `search_screen.dart` - Search functionality
- `my_guides_screen.dart` - User's saved guides
- `guide_steps_screen.dart` - Step-by-step guide view
- `main_navigation_screen.dart` - Bottom navigation
- Follow pattern: StatefulWidget for interactive screens, StatelessWidget for static content

### `/lib/config/`
Configuration and setup:
- `app_config.dart` - Environment and feature flags
- Centralize all configurable values

### `/lib/constants/`
Static values and constants:
- `app_constants.dart` - UI constants, strings, dimensions
- Keep UI constants separate from business logic

### `/lib/utils/`
Helper functions and utilities:
- `logger.dart` - Structured logging
- `theme_extensions.dart` - Custom theme extensions
- Keep utilities pure functions when possible

## Naming Conventions

### Files
- Use snake_case for file names
- Suffix with purpose: `_screen.dart`, `_service.dart`, `_model.dart`
- Group related files in subdirectories

### Classes
- Use PascalCase for class names
- Suffix with purpose: `Screen`, `Service`, `Model`
- Example: `GuideStepsScreen`, `StepService`, `StepModel`

### Variables & Methods
- Use camelCase for variables and methods
- Use descriptive names: `fetchStepsForGuide()` not `getSteps()`
- Boolean variables start with `is`, `has`, `can`: `isLoading`, `hasError`

## Code Organization Patterns

### Service Classes
```dart
class StepService {
  static final _client = Supabase.instance.client;
  
  static Future<List<StepModel>> fetchStepsForGuide(String guideId) async {
    // Implementation
  }
}
```

### Model Classes
```dart
class StepModel {
  final String id;
  final String guideId;
  final String title;
  final String? imageUrl;

  StepModel({
    required this.id,
    required this.guideId,
    required this.title,
    this.imageUrl,
  });
}
```

### Screen Structure
```dart
class GuideStepsScreen extends StatefulWidget {
  const GuideStepsScreen({super.key});

  @override
  State<GuideStepsScreen> createState() => _GuideStepsScreenState();
}

class _GuideStepsScreenState extends State<GuideStepsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guide Steps')),
      body: // Implementation
    );
  }
}
```

## Import Organization
1. Dart core libraries
2. Flutter framework imports
3. Third-party package imports
4. Local project imports (relative paths)

```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/steps.dart';
import '../utils/logger.dart';
```

## Asset Organization
- Images: `assets/images/`
- Icons: `assets/icons/`
- Fonts: `assets/fonts/`
- Update `pubspec.yaml` when adding assets