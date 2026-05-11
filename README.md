# Pose Tracker - Fitness AI UI

A production-ready Flutter UI for an AI pose detection physical fitness tracking app.

## Features Built:
- **Onboarding screen** with features explanation and smooth transitions.
- **Home screen** listing exercises (Push-ups, Squats, Jumping Jacks).
- **Camera & Workout screen** (UI mock of AI tracking, rep counter, real-time feedback context).
- **Result screen** with performance stats.
- **History screen** with a log of past workouts.
- **Profile screen** with user stats and settings.
- Modern, minimal, fitness-focused **Material 3** design with **Dark Mode**.
- State management via `provider`.

## How To Run

1. Make sure you have [Flutter](https://docs.flutter.dev/get-started/install) installed on your machine.
2. In the terminal, navigate to this project folder.
3. Run `flutter pub get` to install dependencies (provider, etc.).
4. Run `flutter run` to launch the application on an emulator or a connected device.

## Note:
The camera view is mocked with placeholder elements for demonstration purposes, ready to integrate with real ML libraries (e.g., Google ML Kit Pose Detection). The `CameraWorkoutScreen` includes the placeholder for the camera feed and the overlay layout.
