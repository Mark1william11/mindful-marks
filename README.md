# Mindful Marks 🌿

**Mindful Marks** is a beautifully designed, feature-rich digital journaling application built with Flutter. It's more than just a note-taking app; it's a mindfulness companion designed to transform the act of journaling into a rewarding and insightful experience. This project serves as a comprehensive portfolio piece showcasing a production-ready, scalable, and visually stunning mobile application built from the ground up.

## ✨ Key Features

*   **Offline-First Journaling:** A fast, responsive experience powered by a local **Drift** database. The app works flawlessly with or without an internet connection.
*   **Secure Cloud Sync:** User data is securely authenticated with **Firebase Authentication** and seamlessly synced to a **Firestore** backend, providing data backup and paving the way for a multi-device experience.
*   **The Digital Garden:** A unique, signature feature that visualizes journaling consistency. For every three entries, a new, procedurally generated plant grows in the user's personal garden, creating a powerful metaphor for personal growth.
*   **Mood Analytics:** An insightful dashboard featuring a heatmap calendar that visualizes mood trends over time, helping users discover patterns in their well-being.
*   **Professional Architecture:** Built on a clean, layered architecture (Data, Logic, Presentation) for scalability and maintainability.
*   **Modern Tech Stack:** Leverages a robust, modern stack including **Riverpod** for state management, **GoRouter** for navigation, and `flutter_animate` for delightful UI animations.

## 📸 Screenshots

### App Screenshots

#### Row 1
| Login & Onboarding | Journal Feed | Create Entry |
| :----------------: | :----------: | :----------: |
| <img width="240" height="533" alt="Login & Onboarding" src="https://github.com/user-attachments/assets/f1354aa7-228d-44fc-8dd6-bbdf66c53801" /> | <img width="240" height="533" alt="Journal Feed" src="https://github.com/user-attachments/assets/b0f10046-3bdf-469c-abb4-6480ca4ebb98" /> | <img width="240" height="533" alt="Create Entry" src="https://github.com/user-attachments/assets/6b29e7ea-bf2b-4a17-bb3a-86d0d565966c" /> |

#### Row 2
| Digital Garden | Mood Analytics | Settings |
| :------------: | :------------: | :------: |
| <img width="240" height="533" alt="Digital Garden" src="https://github.com/user-attachments/assets/0efe2bb2-2713-4e1d-b73a-2f9d55a6b6bf" /> | <img width="240" height="533" alt="Mood Analytics" src="https://github.com/user-attachments/assets/fa4a1dc8-acf7-41ca-ae87-429300aa27c3" /> | <img width="240" height="533" alt="Settings" src="https://github.com/user-attachments/assets/a5723125-a36d-44b8-ad78-49f94aaecbc9" /> |


## 🛠️ Tech Stack & Architecture

This project was built with a focus on creating a professional, scalable, and maintainable codebase.

### Core Frameworks & Libraries
*   **Framework:** Flutter
*   **State Management:** Riverpod (with Code Generation)
*   **Routing:** GoRouter
*   **Local Database:** Drift (SQLite wrapper)
*   **Backend:** Firebase (Authentication & Firestore)
*   **Animations:** `flutter_animate`
*   **Typography:** `google_fonts`

### Architecture
The codebase follows a strict **Clean Architecture** pattern, separated into three distinct layers:

1.  **Presentation:** Contains all UI-related code (Screens, Widgets, Theme). It is built with modern practices, including the use of `flutter_hooks`.
2.  **Logic:** The brain of the application. It holds all the business logic and state management, orchestrated by Riverpod providers.
3.  **Data:** Responsible for all data operations. It abstracts data sources through the **Repository Pattern**, cleanly separating the local Drift database from the remote Firebase services.

## 🚀 Getting Started

This project uses Firebase. To run it, you will need to create your own Firebase project and add the necessary configuration files.

1.  Clone the repository: `git clone https://github.com/your-username/mindful-marks.git`
2.  Set up a new Firebase project.
3.  Add an Android and iOS app to your Firebase project.
4.  Run the FlutterFire CLI to configure the project: `flutterfire configure`
    *   This will generate `lib/firebase_options.dart`.
    *   It will also prompt you to download `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS). Place these in the correct directories (`android/app/` and `ios/Runner/`).
5.  Run `flutter pub get` to install dependencies.
6.  Run the app: `flutter run`
