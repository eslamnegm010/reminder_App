# Reminder Application

A feature-rich Flutter application designed for efficient task management and location-based reminders. This application demonstrates a robust architecture using BLoC for state management, Hive for local persistence, and comprehensive localization support.

## 🚀 Features

- **Smart Reminders**: Create and manage reminders seamlessly.
  - **Time-Based**: Schedule reminders for specific dates and times.
- **User Profiles**: Personalized user experience with profile management.
- **Localization Application**:
  - Full support for **English** and **Arabic**.
  - RTL (Right-to-Left) layout support.
- **Theming**:
  - Dynamic **Light** and **Dark** mode toggle.
  - Adaptive UI components.
- **Local Storage**: Fast and offline-capable data persistence.
- **Notifications**: Reliable local notifications system using `flutter_local_notifications`.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Language**: [Dart](https://dart.dev/)
- **State Management**: [Flutter Bloc (Cubit)](https://pub.dev/packages/flutter_bloc)
- **Local Storage**: [Hive](https://pub.dev/packages/hive) & [Shared Preferences](https://pub.dev/packages/shared_preferences)
- **Localization**: [Easy Localization](https://pub.dev/packages/easy_localization)
- **Notifications**: [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- **Navigation**: Standard Flutter Navigation with [Page Transition](https://pub.dev/packages/page_transition)
- **Assets**: SVG support via `flutter_svg`, cached images via `cached_network_image`.

## 📂 Project Structure

The project follows a **Feature-First Architecture** or **Clean Architecture** inspired structure:

```
lib/
├── core/                   # Core utilities and services
│   ├── init/               # App initialization logic (Providers, Services)
│   ├── local_storage/      # Hive and storage implementations
│   ├── notifications/      # Notification services and handlers
│   └── utils/              # Helper functions, constants, and extensions
├── features/               # Feature modules
│   ├── app_home_screen/    # Main landing/navigation screen
│   ├── reminder/           # Reminder feature (Logic, UI, Models)
│   ├── user/               # User profile feature
│   ├── settings/           # App settings
│   └── splash_screen/      # Splash screen logic
├── res/                    # Resources (Assets, styles)
├── routes/                 # Navigation routes configuration
├── sheared_widgets/        # Common reusable widgets (Shared Widgets)
└── main.dart               # Application entry point
```

## 🏁 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version >=3.10.0 <4.0.0)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/eslamnegm010/reminder_App.git
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Run Code Generation (if needed for Hive/Bloc):**

    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the application:**
    ```bash
    flutter run
    ```

## 🌍 Localization

The app supports **English (`en`)** and **Arabic (`ar`)**.
Translations are located in `assets/translations/`.

To add a new language:

1.  Add the locale JSON file in `assets/translations/`.
2.  Update the `supportedLocales` list in `main.dart`.

## 🎨 Theming

The app uses `ThemeCubit` to handle theme switching.

- **Light Theme**: Default bright color palette.
- **Dark Theme**: Optimized for low-light environments.

---

# Developed by Eslam Negm

# linkedin - https://www.linkedin.com/in/eslam-negm-mobile-dev/

# with Flutter.
