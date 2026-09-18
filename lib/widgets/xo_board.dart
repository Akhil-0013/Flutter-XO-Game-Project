import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game_enums.dart';
import 'xo_painter.dart';

class XoBoardWidget extends StatelessWidget {
  final List<PlayerMark> board;
  final WinningMatch? winningMatch;
  final Animation<double>? winAnimation;
  final Function(int) onTileTapped;
  final bool isInteractive;

  const XoBoardWidget({
    super.key,
    required this.board,
    required this.winningMatch,
    required this.winAnimation,
    required this.onTileTapped,
    this.isInteractive = true,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFF334155), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Grid of 9 cells
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final mark = board[index];
                final isWinningTile =
                    winningMatch?.winningIndices.contains(index) ?? false;

                return _BoardTile(
                  index: index,
                  mark: mark,
                  isWinning: isWinningTile,
                  onTap: () {
                    if (isInteractive && mark == PlayerMark.none) {
                      HapticFeedback.lightImpact();
                      onTileTapped(index);
                    }
                  },
                );
              },
            ),

            // Winning strike line overlay
            if (winningMatch != null && winAnimation != null)
              AnimatedBuilder(
                animation: winAnimation!,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: WinningLinePainter(
                      winningMatch: winningMatch!,
                      animationProgress: winAnimation!.value,
                      lineColor: winningMatch!.winner == PlayerMark.x
                          ? const Color(0xFFF43F5E)
                          : const Color(0xFF06B6D4),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _BoardTile extends StatelessWidget {
  final int index;
  final PlayerMark mark;
  final bool isWinning;
  final VoidCallback onTap;

  const _BoardTile({
    required this.index,
    required this.mark,
    required this.isWinning,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: const Color(0xFF38BDF8).withValues(alpha: 0.2),
        highlightColor: const Color(0xFF38BDF8).withValues(alpha: 0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: isWinning
                ? (mark == PlayerMark.x
                    ? const Color(0xFFF43F5E).withValues(alpha: 0.2)
                    : const Color(0xFF06B6D4).withValues(alpha: 0.2))
                : const Color(0xFF0F172A).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isWinning
                  ? (mark == PlayerMark.x
                      ? const Color(0xFFF43F5E)
                      : const Color(0xFF06B6D4))
                  : const Color(0xFF334155).withValues(alpha: 0.6),
              width: isWinning ? 2.5 : 1.5,
            ),
          ),
          child: Center(
            child: _buildMarkWidget(),
          ),
        ),
      ),
    );
  }

  Widget _buildMarkWidget() {
    switch (mark) {
      case PlayerMark.x:
        return XMarkWidget(
          size: 58,
          isWinning: isWinning,
        );
      case PlayerMark.o:
        return OMarkWidget(
          size: 58,
          isWinning: isWinning,
        );
      case PlayerMark.none:
        return const SizedBox.shrink();
    }
  }
}
