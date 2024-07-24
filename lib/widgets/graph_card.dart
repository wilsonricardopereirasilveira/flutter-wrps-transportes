import 'package:flutter/material.dart';

class GraphCard extends StatelessWidget {
  final String title;
  final CustomPainter painter;
  final double height;
  final List<Widget>? legend;
  final bool isTruckRoute;

  GraphCard({
    required this.title,
    required this.painter,
    required this.height,
    this.legend,
    this.isTruckRoute = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: height,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isTruckRoute)
                  Icon(Icons.local_shipping,
                      color: Color(0xFF301B64), size: 20),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF301B64),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomPaint(
                  painter: painter,
                  size: Size.infinite,
                ),
              ),
            ),
            if (legend != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: legend!,
              ),
          ],
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  LegendItem({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
