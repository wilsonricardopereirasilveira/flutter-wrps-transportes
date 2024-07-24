import 'package:flutter/material.dart';
import 'package:website_transwrps/widgets/gauge_chart_card.dart';

class CombinedCard extends StatelessWidget {
  final double screenWidth;

  CombinedCard({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GaugeChartCard(
                      title: '',
                      value: 85,
                      centerText: '85%',
                      bottomText: 'Tempo de entrega',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDistanceTypesGraph(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceTypesGraph() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildDistanceTypeRow('Plan Promedio', '150km', 70),
        const SizedBox(height: 16),
        _buildDistanceTypeRow('Plan Max', '150km', 70),
        const SizedBox(height: 16),
        _buildDistanceTypeRow('Real Promedio', '40km', 10),
        const SizedBox(height: 16),
        _buildDistanceTypeRow('Real Max', '100km', 55),
      ],
    );
  }

  Widget _buildDistanceTypeRow(String label, String value, double percent) {
    Color barColor = const Color(0xFF301B64).withOpacity(percent / 100);
    Color backgroundColor = percent == 0 ? Colors.grey[300]! : barColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF301B64),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 16,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: FractionallySizedBox(
            widthFactor: percent / 100,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
