import 'package:flutter/material.dart';
import '../models/game_enums.dart';

class ScoreBoardWidget extends StatelessWidget {
  final int scoreX;
  final int scoreO;
  final int scoreTies;
  final PlayerMark currentTurn;
  final GameMode gameMode;
  final PlayerMark humanPlayer;

  const ScoreBoardWidget({
    super.key,
    required this.scoreX,
    required this.scoreO,
    required this.scoreTies,
    required this.currentTurn,
    required this.gameMode,
    required this.humanPlayer,
  });

  String _getPlayerLabel(PlayerMark mark) {
    if (gameMode == GameMode.passAndPlay) {
      return mark == PlayerMark.x ? 'Player X' : 'Player O';
    } else {
      if (mark == humanPlayer) {
        return 'You (${mark.label})';
      } else {
        return gameMode == GameMode.vsAiEasy ? 'AI Easy' : 'AI Pro';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isXActive = currentTurn == PlayerMark.x;
    final isOActive = currentTurn == PlayerMark.o;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF334155), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Player X Box
          _PlayerCard(
            title: _getPlayerLabel(PlayerMark.x),
            symbol: 'X',
            score: scoreX,
            symbolColor: const Color(0xFFF43F5E),
            isActive: isXActive,
          ),

          // Ties Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'DRAWS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$scoreTies',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Player O Box
          _PlayerCard(
            title: _getPlayerLabel(PlayerMark.o),
            symbol: 'O',
            score: scoreO,
            symbolColor: const Color(0xFF06B6D4),
            isActive: isOActive,
          ),
        ],
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final String title;
  final String symbol;
  final int score;
  final Color symbolColor;
  final bool isActive;

  const _PlayerCard({
    required this.title,
    required this.symbol,
    required this.score,
    required this.symbolColor,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? symbolColor.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? symbolColor : Colors.transparent,
          width: 2,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: symbolColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                symbol,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: symbolColor,
                ),
              ),
              const SizedBox(width: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 80),
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$score',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: isActive ? Colors.white : const Color(0xFFE2E8F0),
            ),
          ),
        ],
      ),
    );
  }
}
