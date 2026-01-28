# Ditonton

A Flutter application for browsing movies and TV series information using The Movie Database (TMDb) API.

## Features

- BLoC State Management - Uses flutter_bloc for reactive state management
- SSL Certificate Pinning - Secure API communication with pinned certificates
- Firebase Analytics - User behavior and app usage tracking
- Firebase Crashlytics - Real-time crash reporting and error monitoring
- Continuous Integration - Automated testing with GitHub Actions
- Clean Architecture - Modular and maintainable code structure

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── injection.dart            # Dependency injection setup
├── firebase_options.dart     # Firebase configuration
├── common/                   # Shared utilities
│   ├── constants.dart        # App constants and API keys
│   ├── exception.dart        # Custom exceptions
│   ├── failure.dart          # Failure classes for error handling
│   ├── ssl_pinning.dart      # SSL certificate pinning implementation
│   ├── state_enum.dart       # State enumerations
│   └── utils.dart            # Utility functions
├── data/                     # Data layer
│   ├── datasources/          # Remote and local data sources
│   ├── models/               # Data models (JSON serialization)
│   └── repositories/         # Repository implementations
├── domain/                   # Domain layer
│   ├── entities/             # Business entities
│   ├── repositories/         # Repository interfaces
│   └── usecases/             # Business logic use cases
└── presentation/             # Presentation layer
    ├── bloc/                 # BLoC state management
    │   ├── movie/            # Movie-related BLoCs
    │   └── tv/               # TV series-related BLoCs
    ├── pages/                # UI screens
    ├── provider/             # Legacy providers (kept for reference)
    └── widgets/              # Reusable UI components
```

## Tech Stack

- Flutter 3.27.1
- Dart 3.6.0
- flutter_bloc 8.1.6
- firebase_core 3.15.2
- firebase_analytics 11.6.0
- firebase_crashlytics 4.3.10
- http with IOClient for SSL pinning
- sqflite for local database
- get_it for dependency injection
- dartz for functional programming

## SSL Pinning Implementation

This application implements SSL certificate pinning to prevent man-in-the-middle attacks. The implementation:

1. Loads pinned certificates from assets (`assets/certificates/`)
2. Creates a SecurityContext with `withTrustedRoots: false`
3. Only trusts the explicitly pinned certificates
4. Rejects any connection with mismatched certificates

Key file: `lib/common/ssl_pinning.dart`

## Firebase Setup

1. Create a project at Firebase Console (https://console.firebase.google.com/)
2. Install FlutterFire CLI:
   ```
   dart pub global activate flutterfire_cli
   ```
3. Configure Firebase:
   ```
   flutterfire configure
   ```
4. The `firebase_options.dart` file will be generated automatically

## Running the Application

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Run with specific device
flutter run -d <device_id>
```

## Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Generate coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
```

## Building

```bash
# Build Android APK
flutter build apk

# Build Android App Bundle
flutter build appbundle

# Build iOS
flutter build ios
```

## Testing Coverage

To generate test coverage reports, follow these steps:

1. Install lcov:
   - Linux: `sudo apt-get install lcov -y`
   - macOS: `brew install lcov`
   - Windows: `choco install lcov`

2. Run the test script:
   ```bash
   ./test.sh
   ```

3. The coverage report will be generated in the `coverage/` directory.

## Architecture

This project follows Clean Architecture principles with three main layers:

1. **Presentation Layer**: Contains UI components (pages, widgets) and state management (BLoC)
2. **Domain Layer**: Contains business logic (use cases) and entity definitions
3. **Data Layer**: Contains data sources, models, and repository implementations

## API Reference

This application uses The Movie Database (TMDb) API. Documentation available at:
https://developers.themoviedb.org/3

## License

This project is created for educational purposes as part of Dicoding Flutter Expert course.

