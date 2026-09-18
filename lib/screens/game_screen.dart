import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game_enums.dart';
import '../models/game_logic.dart';
import '../widgets/score_card.dart';
import '../widgets/xo_board.dart';
import '../widgets/xo_painter.dart';

class GameScreen extends StatefulWidget {
  final GameMode gameMode;
  final PlayerMark humanPlayer;

  const GameScreen({
    super.key,
    required this.gameMode,
    this.humanPlayer = PlayerMark.x,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late GameLogic _game;
  late AnimationController _winAnimController;
  late Animation<double> _winAnimation;
  bool _isAiThinking = false;

  @override
  void initState() {
    super.initState();
    _game = GameLogic(
      gameMode: widget.gameMode,
      humanPlayer: widget.humanPlayer,
    );

    _winAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _winAnimation = CurvedAnimation(
      parent: _winAnimController,
      curve: Curves.easeOutCubic,
    );

    // If AI starts first
    if (_game.gameMode != GameMode.passAndPlay &&
        _game.currentTurn == _game.aiPlayer) {
      _triggerAiMove();
    }
  }

  @override
  void dispose() {
    _winAnimController.dispose();
    super.dispose();
  }

  void _onTileTapped(int index) {
    if (_isAiThinking || _game.isGameOver) return;

    if (_game.gameMode != GameMode.passAndPlay &&
        _game.currentTurn != _game.humanPlayer) {
      return;
    }

    final success = _game.makeMove(index);
    if (!success) return;

    setState(() {});

    _handleMoveResult();
  }

  void _handleMoveResult() {
    if (_game.isGameOver) {
      HapticFeedback.heavyImpact();
      if (_game.winningMatch != null) {
        _winAnimController.forward(from: 0.0);
      }
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) _showGameOverDialog();
      });
      return;
    }

    // If against AI and it's AI turn
    if (_game.gameMode != GameMode.passAndPlay &&
        _game.currentTurn == _game.aiPlayer) {
      _triggerAiMove();
    }
  }

  void _triggerAiMove() {
    setState(() {
      _isAiThinking = true;
    });

    Timer(const Duration(milliseconds: 500), () {
      if (!mounted || _game.isGameOver) {
        if (mounted) setState(() => _isAiThinking = false);
        return;
      }

      final aiMove = _game.calculateAiMove();
      if (aiMove != null) {
        _game.makeMove(aiMove);
      }

      setState(() {
        _isAiThinking = false;
      });

      _handleMoveResult();
    });
  }

  void _resetMatch() {
    _winAnimController.reset();
    setState(() {
      _game.resetBoard();
      _isAiThinking = false;
    });

    if (_game.gameMode != GameMode.passAndPlay &&
        _game.currentTurn == _game.aiPlayer) {
      _triggerAiMove();
    }
  }

  void _resetScores() {
    setState(() {
      _game.resetScores();
    });
  }

  void _showGameOverDialog() {
    final winner = _game.winningMatch?.winner;
    final isTie = _game.isTie;

    String title;
    String subtitle;
    Widget? iconWidget;

    if (isTie) {
      title = "It's a Draw!";
      subtitle = 'Great minds think alike.';
      iconWidget = const Icon(
        Icons.handshake_rounded,
        size: 56,
        color: Color(0xFFF59E0B),
      );
    } else if (_game.gameMode == GameMode.passAndPlay) {
      title = 'Player ${winner?.label} Wins!';
      subtitle = 'Outstanding strategy!';
      iconWidget = winner == PlayerMark.x
          ? const XMarkWidget(size: 64, isWinning: true)
          : const OMarkWidget(size: 64, isWinning: true);
    } else {
      if (winner == _game.humanPlayer) {
        title = 'Victory!';
        subtitle = 'You defeated the AI!';
        iconWidget = const Icon(
          Icons.emoji_events_rounded,
          size: 64,
          color: Color(0xFFF59E0B),
        );
      } else {
        title = 'AI Wins!';
        subtitle = 'Better luck next round.';
        iconWidget = const Icon(
          Icons.smart_toy_rounded,
          size: 64,
          color: Color(0xFF06B6D4),
        );
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: const BorderSide(color: Color(0xFF334155), width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconWidget != null) ...[
                  iconWidget,
                  const SizedBox(height: 16),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFF475569)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Exit',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _resetMatch();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF38BDF8),
                          foregroundColor: const Color(0xFF0F172A),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.replay_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Play Again',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getTurnStatus() {
    if (_game.isGameOver) {
      if (_game.isTie) return 'Game ended in a draw';
      return 'Winner: Player ${_game.winningMatch?.winner.label}';
    }

    if (_game.gameMode == GameMode.passAndPlay) {
      return "Player ${_game.currentTurn.label}'s Turn";
    } else {
      if (_game.currentTurn == _game.humanPlayer) {
        return 'Your Turn';
      } else {
        return 'AI is thinking...';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.gameMode.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Restart Game',
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF94A3B8)),
            onPressed: _resetMatch,
          ),
          IconButton(
            tooltip: 'Reset Scores',
            icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFF94A3B8)),
            onPressed: () {
              _resetScores();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Scores reset to 0'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Score Board
            ScoreBoardWidget(
              scoreX: _game.scoreX,
              scoreO: _game.scoreO,
              scoreTies: _game.scoreTies,
              currentTurn: _game.currentTurn,
              gameMode: _game.gameMode,
              humanPlayer: _game.humanPlayer,
            ),

            const Spacer(),

            // Turn status indicator banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFF334155),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isAiThinking) ...[
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF38BDF8),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ] else ...[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _game.currentTurn == PlayerMark.x
                            ? const Color(0xFFF43F5E)
                            : const Color(0xFF06B6D4),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    _getTurnStatus(),
                    style: const TextStyle(
                      color: Color(0xFFE2E8F0),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Game Board
            XoBoardWidget(
              board: _game.board,
              winningMatch: _game.winningMatch,
              winAnimation: _winAnimation,
              isInteractive: !_isAiThinking && !_game.isGameOver,
              onTileTapped: _onTileTapped,
            ),

            const Spacer(),

            // Quick reset button
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: OutlinedButton.icon(
                onPressed: _resetMatch,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Reset Board'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFCBD5E1),
                  side: const BorderSide(color: Color(0xFF334155)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
