import 'dart:math';
import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/donut_data_entity.dart';

class MultiDonutPainter extends CustomPainter {
  final List<DonutDataEntity> data;
  final double strokeWidth;
  final double animationValue;
  final Color defaultColor;

  MultiDonutPainter({
    required this.data,
    required this.animationValue,
    this.defaultColor = Colors.grey,
    this.strokeWidth = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.fold(0.0, (sum, e) => sum + e.value);

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -pi / 2;

    if (total == 0) {
      final disabledPaint = Paint()
        ..color = defaultColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        -pi / 2,
        2 * pi,
        false,
        disabledPaint,
      );

      return;
    }

    for (var item in data) {
      final targetSweep = 2 * pi * (item.value / total);

      final sweepAngle = targetSweep * animationValue;

      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.square;

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      /// start tetap pakai target biar posisi stabil
      startAngle += targetSweep;
    }
  }

  @override
  bool shouldRepaint(covariant MultiDonutPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.animationValue != animationValue;
  }
}
