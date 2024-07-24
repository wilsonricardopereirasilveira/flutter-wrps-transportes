import 'package:flutter/material.dart';

class TruckRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2;

    // Desenhar eixos
    canvas.drawLine(Offset(40, size.height - 40), Offset(40, 20), paint);
    canvas.drawLine(Offset(40, size.height - 40),
        Offset(size.width - 20, size.height - 40), paint);

    // Definir cores para os pontos
    final colors = [Colors.green, Colors.blue, Colors.red, Colors.orange];

    // Exemplo de pontos (ajustado para mais dados)
    final points = [
      Offset(60, size.height - 60),
      Offset(100, size.height - 90),
      Offset(140, size.height - 70),
      Offset(180, size.height - 100),
      Offset(220, size.height - 80),
      Offset(260, size.height - 110),
      Offset(300, size.height - 75),
      Offset(340, size.height - 95),
    ];

    // Desenhar pontos de dados
    for (int i = 0; i < points.length; i++) {
      final pointPaint = Paint()
        ..color = colors[i % colors.length]
        ..strokeWidth = 4;
      canvas.drawCircle(points[i], 4, pointPaint);
    }

    // Desenhar linha de tendência
    final linePaint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 1;
    canvas.drawLine(Offset(40, size.height - 50),
        Offset(size.width - 40, size.height - 110), linePaint);

    // Adicionar rótulos dos eixos
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Rótulo do eixo X
    textPainter.text = TextSpan(
      text: 'Km.',
      style: TextStyle(
          color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(size.width - 25,
            size.height - 20)); // Ajustado para baixo e para a direita

    // Rótulo do eixo Y
    textPainter.text = TextSpan(
      text: 'Kg.',
      style: TextStyle(
          color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(10, 10));

    // Adicionar marcações nos eixos
    for (int i = 0; i <= 5; i++) {
      double x = 40 + (size.width - 80) / 5 * i;
      canvas.drawLine(
          Offset(x, size.height - 40), Offset(x, size.height - 35), paint);
      textPainter.text = TextSpan(
        text: '${i * 60}km',
        style: TextStyle(color: Colors.black, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - 15, size.height - 30));
    }

    for (int i = 0; i <= 5; i++) {
      double y = size.height - 40 - (size.height - 80) / 5 * i;
      canvas.drawLine(Offset(35, y), Offset(40, y), paint);
      textPainter.text = TextSpan(
        text: '${i * 10}kg',
        style: TextStyle(color: Colors.black, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - 5));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
