import 'dart:math';

import 'package:flutter/material.dart';
import 'package:website_transwrps/widgets/partial_delivery_painter.dart';

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.3; // Aumentado a espessura do donut

    // Draw the donut segments
    final noTieneEspacioAngle = 2 * pi * 0.5;
    final despachoErradoAngle = 2 * pi * 0.3;
    final otrosAngle = 2 * pi * 0.2;

    paint.color = const Color(0xFF301B64);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        noTieneEspacioAngle, false, paint);

    paint.color = const Color(0xFFAA8EFF);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -pi / 2 + noTieneEspacioAngle, despachoErradoAngle, false, paint);

    paint.color = const Color(0xFFDFD8FF);
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2 + noTieneEspacioAngle + despachoErradoAngle,
        otrosAngle,
        false,
        paint);

    // Draw the center text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '3\nMotivos',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: radius * 0.3, // Aumentado o tamanho da fonte
          fontWeight: FontWeight.bold,
          color: const Color(0xFF301B64),
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
