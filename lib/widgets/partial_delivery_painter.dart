import 'dart:math';

import 'package:flutter/material.dart';

class PartialDeliveryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.8;

    paint.color = Color(0xFF301B64);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      4.18879,
      true,
      paint,
    );

    paint.color = Color(0xFFAA8EFF);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      4.18879,
      1.25664,
      true,
      paint,
    );

    paint.color = Color(0xFFDFD8FF);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      5.44543,
      0.837758,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
