import 'package:flutter/material.dart';

import '../models/bar.dart';

class BallPainter extends CustomPainter {
  final double x;
  final double y;
  final double ballRadius;
  final List<Bar> bars;

  BallPainter(this.x, this.y, this.ballRadius, this.bars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Dibujar la bola
    paint.color = Colors.white;
    canvas.drawCircle(Offset(x, y), ballRadius, paint);

    // Dibujar las barras
    paint.color = Colors.yellow.shade200;
    for (var bar in bars) {
      canvas.drawRect(
        Rect.fromLTWH(bar.x, bar.y, bar.width, bar.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
