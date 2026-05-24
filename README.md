# Cofee — Coffee Proportion Calculator

A Flutter app for calculating coffee-to-water proportions with custom ratios. Save your favorite recipes, switch between light/dark/system themes.

## Features

- **Custom ratio** — set your base coffee (g) and water (ml), e.g. 60g per 1000ml
- **Bidirectional calculation** — enter coffee → water auto-calculates, and vice versa
- **Grind size** — save grind setting alongside each recipe
- **Save & load recipes** — locally stored recipes with tap-to-load
- **Material 3 theming** — light, dark, or follow system

## Downloads

- [Android APK (debug)](https://github.com/dmtsol/cofee/releases/download/v1.0.0/app-debug.apk)
- [Linux x64 (debug)](https://github.com/dmtsol/cofee/releases/download/v1.0.0/cofee-linux.tar.gz)

## Build & Run

```bash
# Get dependencies
flutter pub get

# Run on connected device
flutter run

# Build APK (Android)
flutter build apk --debug
```

## Tech Stack

- Flutter / Dart
- Provider (state management)
- path_provider (JSON file storage)
- shared_preferences (theme persistence)
- Material Design 3
