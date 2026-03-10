import 'package:flutter/material.dart';

class CustomStepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> steps;
  final Color? activeColor;
  final Color? inactiveColor;
  final double circleRadius;
  final double lineHeight;

  const CustomStepIndicator({
    super.key,
    required this.currentStep,
    required this.steps,
    this.activeColor,
    this.inactiveColor,
    this.circleRadius = 14,
    this.lineHeight = 2,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final active = activeColor ?? Theme.of(context).colorScheme.primary;
    final inactive = inactiveColor ??
        (brightness == Brightness.light
            ? Colors.grey.shade300
            : Colors.grey.shade700);

    return LayoutBuilder(builder: (context, constraints) {
      final stepWidth = constraints.maxWidth / steps.length;

      return SizedBox(
        height: 60,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Garis dasar
            Positioned(
              left: stepWidth / 2,
              right: stepWidth / 2,
              top: circleRadius + 4,
              child: Container(
                height: lineHeight,
                color: inactive,
              ),
            ),
            // Garis progress
            Positioned(
              left: stepWidth / 2,
              top: circleRadius + 4,
              child: Container(
                height: lineHeight,
                width: stepWidth * currentStep,
                color: active,
              ),
            ),
            // Lingkaran + label
            Row(
              children: List.generate(steps.length, (index) {
                final isActive = currentStep >= index;

                return SizedBox(
                  width: stepWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: circleRadius,
                        backgroundColor: isActive ? active : inactive,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        steps[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: isActive ? active : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}
