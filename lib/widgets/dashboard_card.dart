import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double screenWidth;

  DashboardCard({
    required this.count,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 40.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      count,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: _getFontSize(screenWidth, 24),
                        fontWeight: FontWeight.bold,
                        color: iconColor,
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: _getFontSize(screenWidth, 16),
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _getFontSize(double screenWidth, double defaultSize) {
    if (screenWidth >= 1024) {
      return defaultSize;
    } else if (screenWidth >= 600) {
      return defaultSize - 2;
    } else {
      return defaultSize - 4;
    }
  }
}
