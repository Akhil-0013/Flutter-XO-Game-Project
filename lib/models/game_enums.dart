enum PlayerMark {
  none,
  x,
  o,
}

extension PlayerMarkExtension on PlayerMark {
  String get label {
    switch (this) {
      case PlayerMark.x:
        return 'X';
      case PlayerMark.o:
        return 'O';
      case PlayerMark.none:
        return '';
    }
  }

  PlayerMark get opponent {
    if (this == PlayerMark.x) return PlayerMark.o;
    if (this == PlayerMark.o) return PlayerMark.x;
    return PlayerMark.none;
  }
}

enum GameMode {
  passAndPlay, // 2 Players on same device
  vsAiEasy, // Random/casual AI
  vsAiUnbeatable, // Minimax algorithm AI
}

extension GameModeExtension on GameMode {
  String get title {
    switch (this) {
      case GameMode.passAndPlay:
        return 'Pass & Play';
      case GameMode.vsAiEasy:
        return 'vs AI (Casual)';
      case GameMode.vsAiUnbeatable:
        return 'vs AI (Unbeatable)';
    }
  }

  String get subtitle {
    switch (this) {
      case GameMode.passAndPlay:
        return '2 Players on this device';
      case GameMode.vsAiEasy:
        return 'Fun and relaxed computer opponent';
      case GameMode.vsAiUnbeatable:
        return 'Flawless Minimax computer opponent';
    }
  }
}

enum WinType {
  row,
  column,
  mainDiagonal,
  antiDiagonal,
}

class WinningMatch {
  final WinType type;
  final int index; // row or column index (0, 1, 2)
  final PlayerMark winner;
  final List<int> winningIndices;

  const WinningMatch({
    required this.type,
    required this.index,
    required this.winner,
    required this.winningIndices,
  });
}
