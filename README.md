<<<<<<< HEAD
# NoteFlow

NoteFlow is a modern, responsive, offline-first notes application built using Flutter and Material 3. It provides a production-grade user experience with comprehensive sorting, filtering, categories, real-time search, color customization, and localized storage.

## Features

- **Intuitive Organization**: Categorize notes (Work, Personal, Study, Ideas, Shopping) and add unlimited customized tag chips.
- **Micro-Interactions & Quick Actions**: Support for pinning important notes, favoriting, and archiving.
- **Robust Persistence**: Operates fully offline using highly-performant local key-value storage via Hive CE.
- **Advanced Search, Filter & Sort**: Real-time interactive search across fields (title, content, tags, category). Sort by updated time, creation time, or alphabetically.
- **Modern UI Forms**: Full-featured form validation (Title limit, Content limit) and color palette picker. Includes confirmation guards on destructive actions and unsaved changes.
- **Theme Support**: Fully adaptive Material 3 central theme handling Light, Dark, and System Default options.
- **Backup & Share**: Comprehensive JSON import/export validation mechanisms and note sharing.

## Technologies Used

- **Framework**: Flutter
- **Language**: Dart
- **Design Language**: Material 3
- **State Management**: Flutter Riverpod
- **Local Database**: Hive / Hive Flutter (Custom Type Adapters for no-codegen fast builds)
- **Navigation**: GoRouter
- **Typography**: Google Fonts
- **Utilities**: `uuid`, `intl`, `share_plus`

## Project Structure

```text
lib/
├── app/
│   ├── app.dart           # Root MaterialApp.router setup
│   └── router.dart        # Route specifications for all 8 screens
├── core/
│   └── theme/             # Centralized design token system (Colors, Typo, Schemes)
└── features/
    └── notes/
        ├── data/          # Note model, local datasource, and repositories
        └── presentation/  # Riverpod providers, screens, and custom reusable widgets
```

## Installation & Running

1. Install the Flutter SDK (v3.16.x or newer recommended).
2. Clone the repository and navigate to the project directory.
3. Fetch dependencies:
   ```bash
   flutter pub get
   ```
4. Run the project locally:
   ```bash
   flutter run
   ```

## Testing

NoteFlow contains unit tests verifying the integrity of the data structures and serialization parameters. Run them using:
```bash
flutter test
```
=======
# mobileapp Ghaffar
>>>>>>> 5b08c0192986c7ad9a968cb5414c5c942daba7ae
