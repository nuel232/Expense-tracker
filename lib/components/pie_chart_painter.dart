// Custom Painter for Pie Chart
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class PieChartPainter extends CustomPainter {
  final Map<String, double> data;
  final Color Function(String) getCategoryColor;
  final Color backgroundColor;

  PieChartPainter({
    required this.data,
    required this.getCategoryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final total = data.values.reduce((a, b) => a + b);

    double startAngle = -math.pi / 2;

    for (final entry in data.entries) {
      final sweepAngle = (entry.value / total) * 2 * math.pi;

      final paint = Paint()
        ..color = getCategoryColor(entry.key)
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw center circle (donut effect)
    final centerPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.4, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
