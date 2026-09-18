import 'package:flutter_test/flutter_test.dart';
import 'package:xo_game/models/game_enums.dart';
import 'package:xo_game/models/game_logic.dart';

void main() {
  group('GameLogic Win & Tie Tests', () {
    test('Detects Row Win', () {
      final game = GameLogic();
      // Row 0: 0, 1, 2
      game.makeMove(0); // X
      game.makeMove(3); // O
      game.makeMove(1); // X
      game.makeMove(4); // O
      game.makeMove(2); // X (Wins!)

      expect(game.isGameOver, isTrue);
      expect(game.winningMatch?.winner, PlayerMark.x);
      expect(game.winningMatch?.type, WinType.row);
      expect(game.winningMatch?.winningIndices, [0, 1, 2]);
      expect(game.scoreX, 1);
    });

    test('Detects Column Win', () {
      final game = GameLogic();
      // Column 1: 1, 4, 7
      game.makeMove(0); // X
      game.makeMove(1); // O
      game.makeMove(2); // X
      game.makeMove(4); // O
      game.makeMove(5); // X
      game.makeMove(7); // O (Wins!)

      expect(game.isGameOver, isTrue);
      expect(game.winningMatch?.winner, PlayerMark.o);
      expect(game.winningMatch?.type, WinType.column);
      expect(game.winningMatch?.winningIndices, [1, 4, 7]);
      expect(game.scoreO, 1);
    });

    test('Detects Main Diagonal Win', () {
      final game = GameLogic();
      // Main Diagonal: 0, 4, 8
      game.makeMove(0); // X
      game.makeMove(1); // O
      game.makeMove(4); // X
      game.makeMove(2); // O
      game.makeMove(8); // X (Wins!)

      expect(game.isGameOver, isTrue);
      expect(game.winningMatch?.winner, PlayerMark.x);
      expect(game.winningMatch?.type, WinType.mainDiagonal);
      expect(game.winningMatch?.winningIndices, [0, 4, 8]);
    });

    test('Detects Anti Diagonal Win', () {
      final game = GameLogic();
      // Anti Diagonal: 2, 4, 6
      game.makeMove(2); // X
      game.makeMove(0); // O
      game.makeMove(4); // X
      game.makeMove(1); // O
      game.makeMove(6); // X (Wins!)

      expect(game.isGameOver, isTrue);
      expect(game.winningMatch?.winner, PlayerMark.x);
      expect(game.winningMatch?.type, WinType.antiDiagonal);
      expect(game.winningMatch?.winningIndices, [2, 4, 6]);
    });

    test('Detects Tie Game', () {
      final game = GameLogic();
      // X O X
      // X X O
      // O X O
      // Moves:
      game.board = [
        PlayerMark.x, PlayerMark.o, PlayerMark.x,
        PlayerMark.x, PlayerMark.x, PlayerMark.o,
        PlayerMark.o, PlayerMark.x, PlayerMark.o,
      ];
      expect(GameLogic.checkWin(game.board), isNull);
      expect(GameLogic.checkTie(game.board), isTrue);
    });
  });

  group('Minimax AI Logic Tests', () {
    test('AI takes immediate winning move', () {
      final game = GameLogic(
        gameMode: GameMode.vsAiUnbeatable,
        humanPlayer: PlayerMark.x,
      );
      // O has 0, 1 -> should choose 2 to win
      game.board[0] = PlayerMark.o;
      game.board[1] = PlayerMark.o;
      game.board[3] = PlayerMark.x;
      game.board[4] = PlayerMark.x;
      game.currentTurn = PlayerMark.o;

      final move = game.calculateAiMove();
      expect(move, equals(2));
    });

    test('AI blocks human winning move', () {
      final game = GameLogic(
        gameMode: GameMode.vsAiUnbeatable,
        humanPlayer: PlayerMark.x,
      );
      // Human X has 0, 1 -> AI O must block at 2
      game.board[0] = PlayerMark.x;
      game.board[1] = PlayerMark.x;
      game.currentTurn = PlayerMark.o;

      final move = game.calculateAiMove();
      expect(move, equals(2));
    });

    test('AI never loses against random moves in 20 simulations', () {
      for (int sim = 0; sim < 20; sim++) {
        final game = GameLogic(
          gameMode: GameMode.vsAiUnbeatable,
          humanPlayer: PlayerMark.x,
        );

        while (!game.isGameOver) {
          if (game.currentTurn == PlayerMark.x) {
            final available = GameLogic.getAvailableIndices(game.board);
            if (available.isEmpty) break;
            game.makeMove(available.first);
          } else {
            final aiMove = game.calculateAiMove();
            expect(aiMove, isNotNull);
            game.makeMove(aiMove!);
          }
        }

        // Unbeatable AI should either win or draw, NEVER lose
        expect(game.winningMatch?.winner != PlayerMark.x, isTrue,
            reason: 'Minimax AI should never lose!');
      }
    });
  });
}
