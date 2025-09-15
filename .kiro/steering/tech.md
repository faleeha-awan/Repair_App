# Technology Stack

## Framework & Language
- **Flutter 3.9+**: Cross-platform UI framework
- **Dart**: Primary programming language
- **Material Design 3**: UI design system with custom theming

## Backend & Database
- **Supabase**: Backend-as-a-Service for authentication, database, and real-time features
- **PostgreSQL**: Database (via Supabase)
- **Row Level Security**: Database security model

## Key Dependencies
- `supabase_flutter`: Backend integration
- `flex_seed_scheme`: Advanced Material 3 theming
- `shared_preferences`: Local data persistence
- `http`: HTTP client for API calls
- `file_picker` & `image_picker`: File handling
- `json_annotation` & `json_serializable`: JSON serialization

## Development Tools
- `flutter_lints`: Code quality and style enforcement
- `build_runner`: Code generation
- `flutter_test`: Unit and widget testing

## Architecture Patterns
- **Service Layer Pattern**: Centralized business logic in service classes
- **Repository Pattern**: Data access abstraction
- **Provider/Listenable Pattern**: State management (ThemeService)
- **Clean Architecture**: Separation of concerns between UI, business logic, and data

## Common Commands

### Development
```bash
# Get dependencies
flutter pub get

# Run code generation
flutter packages pub run build_runner build

# Run app in debug mode
flutter run

# Run on specific device
flutter run -d chrome
flutter run -d windows
```

### Testing
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Build & Deploy
```bash
# Build for Android
flutter build apk --release
flutter build appbundle --release

# Build for iOS
flutter build ios --release

# Build for web
flutter build web --release

# Build for desktop
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

## Code Generation
The project uses code generation for JSON serialization. Run this after modifying model classes:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```