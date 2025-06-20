# Yoga Breathing App

A simple Flutter app to guide users through customizable yoga breathing sessions with voice instructions.

## Features

- **Splash Screen**: Animated splash screen on launch.
- **Customizable Yoga Session**: Set number of rounds, inhale/hold/exhale durations.
- **Voice Guidance**: Uses Text-to-Speech (TTS) to guide each phase (inhale, hold, exhale).
- **Progress Tracking**: Displays current round and phase.
- **Material Design**: Clean and modern UI.

## Getting Started

1. **Clone the repository:**
   ```sh
   git clone <your-repo-url>
   cd yoga_app
   ```
2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Run the app:**
   ```sh
   flutter run
   ```

## Usage

1. Launch the app. The splash screen will appear briefly.
2. On the main screen, set your desired number of rounds and durations for inhale, hold, and exhale.
3. Press **Start Session**. The app will:
   - Announce each round and phase (inhale, hold, exhale) using voice guidance.
   - Show a countdown timer for each phase.
   - Automatically proceed through all rounds.
4. At the end, you’ll receive a completion message.

## Dependencies

- [flutter_tts](https://pub.dev/packages/flutter_tts): For text-to-speech guidance.
- [cupertino_icons](https://pub.dev/packages/cupertino_icons): iOS-style icons.

## Folder Structure

- `lib/main.dart` – App entry point.
- `lib/splash_screen.dart` – Splash screen implementation.
- `lib/yoga_session/yoga_screen.dart` – Main yoga session logic and UI.

## License

This project is for educational purposes.
