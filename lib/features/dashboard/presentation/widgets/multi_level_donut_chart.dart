import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/donut_data_entity.dart';
import 'package:workorder_company_app/features/dashboard/presentation/widgets/multi_donut_painter.dart';

class MultiLevelDonutChart extends StatelessWidget {
  /// Example Use:
  /// [
  ///   [active, inactive], // ring luar
  ///   [manager, staff],   // ring tengah
  ///   [done, failed]      // ring dalam
  /// ]
  final List<List<DonutDataEntity>> levels;

  final double size;
  final double strokeWidth;
  final double gap;
  final double animationValue;

  const MultiLevelDonutChart({
    super.key,
    required this.levels,
    required this.animationValue,
    this.size = 220,
    this.strokeWidth = 8,
    this.gap = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(levels.length, (index) {
          final levelSize = size - ((strokeWidth + gap) * index * 2);

          return SizedBox(
            width: levelSize,
            height: levelSize,
            child: CustomPaint(
              painter: MultiDonutPainter(
                defaultColor: Theme.of(context).colorScheme.primaryContainer,
                data: levels[index],
                strokeWidth: strokeWidth,
                animationValue: animationValue,
              ),
            ),
          );
        }),
      ),
    );
  }
}
