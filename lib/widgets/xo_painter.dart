import 'package:flutter/material.dart';
import '../models/game_enums.dart';

class XMarkWidget extends StatelessWidget {
  final double size;
  final Color color;
  final bool isWinning;

  const XMarkWidget({
    super.key,
    this.size = 64,
    this.color = const Color(0xFFF43F5E),
    this.isWinning = false,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: CustomPaint(
            size: Size(size, size),
            painter: _XPainter(
              color: color,
              isWinning: isWinning,
            ),
          ),
        );
      },
    );
  }
}

class _XPainter extends CustomPainter {
  final Color color;
  final bool isWinning;

  _XPainter({required this.color, required this.isWinning});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeW = size.width * 0.16;

    if (isWinning) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.5)
        ..strokeWidth = strokeW * 2.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      final p1 = Offset(size.width * 0.2, size.height * 0.2);
      final p2 = Offset(size.width * 0.8, size.height * 0.8);
      final p3 = Offset(size.width * 0.8, size.height * 0.2);
      final p4 = Offset(size.width * 0.2, size.height * 0.8);

      canvas.drawLine(p1, p2, glowPaint);
      canvas.drawLine(p3, p4, glowPaint);
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final p1 = Offset(size.width * 0.22, size.height * 0.22);
    final p2 = Offset(size.width * 0.78, size.height * 0.78);
    final p3 = Offset(size.width * 0.78, size.height * 0.22);
    final p4 = Offset(size.width * 0.22, size.height * 0.78);

    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p3, p4, paint);
  }

  @override
  bool shouldRepaint(covariant _XPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isWinning != isWinning;
  }
}

class OMarkWidget extends StatelessWidget {
  final double size;
  final Color color;
  final bool isWinning;

  const OMarkWidget({
    super.key,
    this.size = 64,
    this.color = const Color(0xFF06B6D4),
    this.isWinning = false,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: CustomPaint(
            size: Size(size, size),
            painter: _OPainter(
              color: color,
              isWinning: isWinning,
            ),
          ),
        );
      },
    );
  }
}

class _OPainter extends CustomPainter {
  final Color color;
  final bool isWinning;

  _OPainter({required this.color, required this.isWinning});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeW = size.width * 0.16;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width * 0.32);

    if (isWinning) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.5)
        ..strokeWidth = strokeW * 2.0
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(center, radius, glowPaint);
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeW
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _OPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isWinning != isWinning;
  }
}

class WinningLinePainter extends CustomPainter {
  final WinningMatch winningMatch;
  final double animationProgress; // 0.0 to 1.0
  final Color lineColor;

  WinningLinePainter({
    required this.winningMatch,
    required this.animationProgress,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (animationProgress <= 0.0) return;

    final cellW = size.width / 3;
    final cellH = size.height / 3;

    Offset start = Offset.zero;
    Offset end = Offset.zero;

    switch (winningMatch.type) {
      case WinType.row:
        final y = cellH * winningMatch.index + cellH / 2;
        start = Offset(cellW * 0.15, y);
        end = Offset(size.width - cellW * 0.15, y);
        break;

      case WinType.column:
        final x = cellW * winningMatch.index + cellW / 2;
        start = Offset(x, cellH * 0.15);
        end = Offset(x, size.height - cellH * 0.15);
        break;

      case WinType.mainDiagonal:
        start = Offset(cellW * 0.15, cellH * 0.15);
        end = Offset(size.width - cellW * 0.15, size.height - cellH * 0.15);
        break;

      case WinType.antiDiagonal:
        start = Offset(size.width - cellW * 0.15, cellH * 0.15);
        end = Offset(cellW * 0.15, size.height - cellH * 0.15);
        break;
    }

    // Interpolate current end point based on animation progress
    final currentEnd = Offset(
      start.dx + (end.dx - start.dx) * animationProgress,
      start.dy + (end.dy - start.dy) * animationProgress,
    );

    // Outer glow
    final glowPaint = Paint()
      ..color = lineColor.withValues(alpha: 0.5)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawLine(start, currentEnd, glowPaint);

    // Inner bright line
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, currentEnd, linePaint);
  }

  @override
  bool shouldRepaint(covariant WinningLinePainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress ||
        oldDelegate.winningMatch != winningMatch ||
        oldDelegate.lineColor != lineColor;
  }
}
