# 🎮 XO Game (Tic Tac Toe) - Flutter

A sleek, modern, and high-performance **XO Game (Tic Tac Toe)** cross-platform application built with **Flutter** and **Dart**, designed specifically for **Android** and **iOS**.

Featuring a cyber-dark aesthetic, custom vector graphics, animated victory strikes, and an unbeatable **Minimax AI** engine.

---

## ✨ Features

- **📱 Cross-Platform Ready**: Fully configured and tested for both **Android** and **iOS** mobile platforms.
- **👥 2-Player Pass & Play**: Challenge friends on the same device with intuitive turn indicators and animated player cards.
- **🤖 Smart AI Opponents**:
  - **Casual Mode**: Relaxed computer opponent for casual practice.
  - **Unbeatable Mode**: Powered by the **Minimax Algorithm** with alpha-beta search, guaranteeing the AI never makes a losing move.
- **🎨 Modern Dark UI / UX**:
  - Rich slate-dark background (`#0F172A`) with vibrant electric cyan (`#06B6D4`) and neon rose (`#F43F5E`) highlights.
  - Custom vector-rendered 'X' and 'O' symbols with glowing strike-through animations on winning rows/columns/diagonals.
  - Native haptic feedback on taps and winning moves.
- **📊 Real-time Scoreboard**: Track Player X wins, Player O wins, and Draws dynamically across rounds.
- **⚡ Zero Bloat**: Zero heavy third-party UI dependencies—uses native Flutter Canvas CustomPainters and Flutter animations for buttery-smooth 60/120 FPS performance.

---

## 📸 Game Modes

| Mode | Description |
| :--- | :--- |
| **Pass & Play** | Two players take turns on the same device. |
| **vs AI (Casual)** | Computer chooses random moves with occasional tactical blocks. |
| **vs AI (Unbeatable)** | Computer calculates every future move via Minimax, rendering it impossible to defeat. |

---

## 📂 Project Structure

```
xo_game/
├── android/                   # Native Android configuration & manifest
├── ios/                       # Native iOS Xcode project
├── lib/
│   ├── main.dart              # App entry point, system overlay & dark theme
│   ├── models/
│   │   ├── game_enums.dart    # Enums for PlayerMark, GameMode, WinType
│   │   └── game_logic.dart    # Game state engine, win/tie checks, Minimax AI
│   ├── widgets/
│   │   ├── xo_painter.dart    # Custom vector painters for X, O, & strike lines
│   │   ├── xo_board.dart      # Interactive 3x3 game board with responsive tiles
│   │   └── score_card.dart    # Scoreboard and turn indicator card
│   └── screens/
│       ├── home_screen.dart   # Mode selection & symbol chooser screen
│       └── game_screen.dart   # Active match screen with victory dialogs
└── test/
    ├── game_logic_test.dart   # Unit tests for win patterns & Minimax AI
    └── widget_test.dart       # Widget smoke tests
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.12+ recommended)
- [Android Studio](https://developer.android.com/studio) (for Android emulation) and/or [Xcode](https://developer.apple.com/xcode/) (for iOS simulator on macOS)

### Installation

1. Navigate to the project directory:
   ```bash
   cd C:\Users\ongol\Desktop\Flutter\xo_game
   ```

2. Get Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run static analysis:
   ```bash
   flutter analyze
   ```

---

## 📱 Running the App

### On Android
Connect an Android phone with USB debugging enabled, or start an Android emulator:
```bash
flutter run -d android
```

### On iOS (macOS required)
Start the iOS Simulator:
```bash
flutter run -d ios
```

### Quick Desktop / Web Preview
You can also preview and test the app directly on Chrome or Windows desktop:
```bash
flutter run -d chrome
# or
flutter run -d windows
```

---

## 🧪 Testing

The project includes an extensive test suite verifying win condition detection, tie evaluation, Minimax AI logic, and UI smoke testing:

```bash
flutter test
```

### Test Coverage includes:
- ✅ Horizontal row wins (all 3 rows)
- ✅ Vertical column wins (all 3 columns)
- ✅ Diagonal wins (Main & Anti-diagonal)
- ✅ Draw condition when board is full without a winner
- ✅ Minimax AI takes immediate winning move
- ✅ Minimax AI blocks human player's immediate winning move
- ✅ 20-game simulation proving Minimax AI never loses
- ✅ Widget smoke test for home screen components

---

## 🛠️ Built With

- **[Flutter](https://flutter.dev)** - Cross-platform UI toolkit
- **[Dart](https://dart.dev)** - High-performance object-oriented programming language
- **Flutter CustomPainter & Canvas** - Smooth vector rendering for game marks & victory strikes

---

## 📄 License

This project is open-source and free to use for educational and personal projects.
