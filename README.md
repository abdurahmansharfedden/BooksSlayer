# Books Slayer 📚

Books Slayer is a comprehensive mobile application built with Flutter, designed to help users discover, organize, and track their favorite books. Whether you are an avid reader or just starting your journey, this app provides the tools you need to manage your personal library.

## ✨ Features

- **Book Discovery**: Explore a vast collection of books with detailed descriptions and cover art.
- **Reading Tracker**: Keep track of the books you are currently reading, want to read, or have completed.
- **User Authentication**: Secure user accounts to sync your data and preferences.
- **Favorites & Collections**: Save books to your favorites and organize them for easy access.
- **Local Caching**: Seamless experience with offline support using local storage.
- **Modern UI/UX**: A smooth, responsive interface featuring animations and dark mode support.

## 🛠️ Tech Stack

This project relies on a robust stack of modern technologies:

- **Frontend**: Flutter
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Backend Services**: Firebase (Core, Firestore) / HTTP APIs
- **Local Database**: SQLite (sqflite)
- **Utilities**: Intl, Google Fonts, Flutter Animate

## 🚀 Getting Started

Follow these steps to run the project locally:

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

## 📄 Configuration & Dependencies (`pubspec.yaml`)

The `pubspec.yaml` file is the heart of the Flutter project configuration. It defines the project's metadata, limits the SDK version, and manages the external packages that power the application.

### Key Dependencies Breakdown

*   **Core Architecture**:
    *   `flutter_riverpod`: Used for state management, offering a robust way to manage app state and dependency injection.
    *   `go_router`: Handles navigation and routing, allowing for deep linking and declarative route definitions.
    *   `dartz`: Brings functional programming concepts to Dart (e.g., Either, Option).

*   **Backend & Data**:
    *   `firebase_core` & `cloud_firestore`: Integrates the app with Firebase for backend services and real-time database capabilities.
    *   `sqflite` & `path`: Provides a local SQLite database for offline storage and caching.
    *   `http`: Facilitates making network requests to external APIs.

*   **UI & UX**:
    *   `flutter_animate`: Adds declarative, easy-to-use animations to widgets.
    *   `shimmer`: Creates loading skeleton effects for a polished user experience.
    *   `cached_network_image`: Efficiently loads and caches network images to improve performance.
    *   `carousel_slider`: Implements image carousels and sliders.
    *   `google_fonts` & `font_awesome_flutter`: Provides access to a wide range of custom fonts and icons.

*   **Utilities**:
    *   `intl`: Handles internationalization and date/number formatting.
    *   `uuid`: Generates unique identifiers for entities.
    *   `url_launcher`: Enables launching external URLs (browser, email, phone).

### Dev Dependencies
*   `flutter_lints`: Enforces coding standards and best practices.
*   `flutter_launcher_icons`: configuration tool to automatically generate app launcher icons for Android and iOS.

