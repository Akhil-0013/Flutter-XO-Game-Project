import 'dart:math';
import 'game_enums.dart';

class GameLogic {
  List<PlayerMark> board = List.filled(9, PlayerMark.none);
  PlayerMark currentTurn = PlayerMark.x;
  GameMode gameMode = GameMode.passAndPlay;
  PlayerMark humanPlayer = PlayerMark.x;

  int scoreX = 0;
  int scoreO = 0;
  int scoreTies = 0;

  bool isGameOver = false;
  WinningMatch? winningMatch;
  bool isTie = false;

  final Random _random = Random();

  GameLogic({
    this.gameMode = GameMode.passAndPlay,
    this.humanPlayer = PlayerMark.x,
  });

  PlayerMark get aiPlayer => humanPlayer.opponent;

  void resetBoard() {
    board = List.filled(9, PlayerMark.none);
    currentTurn = PlayerMark.x;
    isGameOver = false;
    winningMatch = null;
    isTie = false;
  }

  void resetScores() {
    scoreX = 0;
    scoreO = 0;
    scoreTies = 0;
  }

  /// Attempts to make a move at [index].
  /// Returns true if move was valid and made.
  bool makeMove(int index) {
    if (index < 0 || index >= 9 || board[index] != PlayerMark.none || isGameOver) {
      return false;
    }

    board[index] = currentTurn;

    final win = checkWin(board);
    if (win != null) {
      isGameOver = true;
      winningMatch = win;
      if (win.winner == PlayerMark.x) {
        scoreX++;
      } else if (win.winner == PlayerMark.o) {
        scoreO++;
      }
      return true;
    }

    if (checkTie(board)) {
      isGameOver = true;
      isTie = true;
      scoreTies++;
      return true;
    }

    // Switch turn
    currentTurn = currentTurn.opponent;
    return true;
  }

  /// Calculates the AI move index. Returns null if board full or game over.
  int? calculateAiMove() {
    if (isGameOver) return null;

    final available = getAvailableIndices(board);
    if (available.isEmpty) return null;

    if (gameMode == GameMode.vsAiEasy) {
      return _calculateEasyAiMove(available);
    } else if (gameMode == GameMode.vsAiUnbeatable) {
      return _calculateMinimaxAiMove();
    }
    return null;
  }

  int _calculateEasyAiMove(List<int> available) {
    // 1. If AI can win in 1 move, take it
    for (final idx in available) {
      final copy = List<PlayerMark>.from(board);
      copy[idx] = aiPlayer;
      if (checkWin(copy)?.winner == aiPlayer) {
        return idx;
      }
    }

    // 2. 60% chance to block human win if available
    if (_random.nextDouble() < 0.60) {
      for (final idx in available) {
        final copy = List<PlayerMark>.from(board);
        copy[idx] = humanPlayer;
        if (checkWin(copy)?.winner == humanPlayer) {
          return idx;
        }
      }
    }

    // 3. Otherwise pick a random available spot
    return available[_random.nextInt(available.length)];
  }

  int _calculateMinimaxAiMove() {
    int bestScore = -10000;
    int bestMove = -1;

    final available = getAvailableIndices(board);
    // If board is completely empty, pick center or random corner for speed
    if (available.length == 9) {
      const cornersAndCenter = [0, 2, 4, 6, 8];
      return cornersAndCenter[_random.nextInt(cornersAndCenter.length)];
    }

    for (final index in available) {
      board[index] = aiPlayer;
      final score = _minimax(board, 0, false, -10000, 10000);
      board[index] = PlayerMark.none;

      if (score > bestScore) {
        bestScore = score;
        bestMove = index;
      }
    }

    return bestMove != -1 ? bestMove : available.first;
  }

  int _minimax(
    List<PlayerMark> b,
    int depth,
    bool isMaximizing,
    int alpha,
    int beta,
  ) {
    final win = checkWin(b);
    if (win != null) {
      if (win.winner == aiPlayer) {
        return 10 - depth;
      } else if (win.winner == humanPlayer) {
        return depth - 10;
      }
    }

    if (checkTie(b)) {
      return 0;
    }

    final available = getAvailableIndices(b);

    if (isMaximizing) {
      int maxEval = -10000;
      for (final idx in available) {
        b[idx] = aiPlayer;
        final eval = _minimax(b, depth + 1, false, alpha, beta);
        b[idx] = PlayerMark.none;
        maxEval = max(maxEval, eval);
        alpha = max(alpha, eval);
        if (beta <= alpha) break;
      }
      return maxEval;
    } else {
      int minEval = 10000;
      for (final idx in available) {
        b[idx] = humanPlayer;
        final eval = _minimax(b, depth + 1, true, alpha, beta);
        b[idx] = PlayerMark.none;
        minEval = min(minEval, eval);
        beta = min(beta, eval);
        if (beta <= alpha) break;
      }
      return minEval;
    }
  }

  static List<int> getAvailableIndices(List<PlayerMark> b) {
    final list = <int>[];
    for (int i = 0; i < b.length; i++) {
      if (b[i] == PlayerMark.none) {
        list.add(i);
      }
    }
    return list;
  }

  static WinningMatch? checkWin(List<PlayerMark> b) {
    // Check Rows
    for (int r = 0; r < 3; r++) {
      final i1 = r * 3;
      final i2 = i1 + 1;
      final i3 = i1 + 2;
      if (b[i1] != PlayerMark.none && b[i1] == b[i2] && b[i2] == b[i3]) {
        return WinningMatch(
          type: WinType.row,
          index: r,
          winner: b[i1],
          winningIndices: [i1, i2, i3],
        );
      }
    }

    // Check Columns
    for (int c = 0; c < 3; c++) {
      final i1 = c;
      final i2 = c + 3;
      final i3 = c + 6;
      if (b[i1] != PlayerMark.none && b[i1] == b[i2] && b[i2] == b[i3]) {
        return WinningMatch(
          type: WinType.column,
          index: c,
          winner: b[i1],
          winningIndices: [i1, i2, i3],
        );
      }
    }

    // Check Main Diagonal (top-left to bottom-right)
    if (b[0] != PlayerMark.none && b[0] == b[4] && b[4] == b[8]) {
      return WinningMatch(
        type: WinType.mainDiagonal,
        index: 0,
        winner: b[0],
        winningIndices: const [0, 4, 8],
      );
    }

    // Check Anti Diagonal (top-right to bottom-left)
    if (b[2] != PlayerMark.none && b[2] == b[4] && b[4] == b[6]) {
      return WinningMatch(
        type: WinType.antiDiagonal,
        index: 1,
        winner: b[2],
        winningIndices: const [2, 4, 6],
      );
    }

    return null;
  }

  static bool checkTie(List<PlayerMark> b) {
    if (checkWin(b) != null) return false;
    for (final mark in b) {
      if (mark == PlayerMark.none) return false;
    }
    return true;
  }
}
