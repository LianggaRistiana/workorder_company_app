import 'package:flutter/widgets.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/donut_data_entity.dart';
import 'package:workorder_company_app/features/dashboard/presentation/widgets/multi_donut_painter.dart';

class MultiDonutChart extends StatefulWidget {
  final List<DonutDataEntity> data;
  final double size;

  const MultiDonutChart({
    super.key,
    required this.data,
    this.size = 180,
  });

  @override
  State<MultiDonutChart> createState() => _MultiDonutChartState();
}

class _MultiDonutChartState extends State<MultiDonutChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double get total => widget.data.fold(0.0, (sum, e) => sum + e.value);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant MultiDonutChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.data != widget.data) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final animatedTotal = total * _animation.value;

          return Stack(
            alignment: Alignment.center,
            children: [
              /// 🎯 DONUT
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: MultiDonutPainter(
                  data: widget.data,
                  animationValue: _animation.value,
                ),
              ),

              /// 🎯 CENTER TEXT
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    animatedTotal.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
