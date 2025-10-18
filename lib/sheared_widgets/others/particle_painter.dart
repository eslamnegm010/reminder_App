import 'dart:math';
import 'package:flutter/material.dart';

class ParticlePainter extends CustomPainter {
  final double progress;
  final Color color;
  final int particleCount;

  ParticlePainter({
    required this.progress,
    required this.color,
    this.particleCount = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withOpacity(1 - progress);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = 50 * progress;

    for (int i = 0; i < particleCount; i++) {
      final angle = (2 * pi / particleCount) * i;
      final x = center.dx + cos(angle) * radius;
      final y = center.dy + sin(angle) * radius;
      canvas.drawCircle(Offset(x, y), 3 * (1 - progress), paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
