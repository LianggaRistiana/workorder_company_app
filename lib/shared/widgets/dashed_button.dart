import 'package:flutter/material.dart';

class DashedButton extends StatelessWidget {
  final String title;
  final Color borderColor;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool isLoading;

  const DashedButton({
    super.key,
    this.title = "Tambah",
    this.color = Colors.black,
    this.borderColor = Colors.black,
    this.icon = Icons.add,
    this.onTap,
    this.height = 50,
    this.borderRadius = 8,
    this.padding = EdgeInsets.zero,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // penting agar InkWell terlihat
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: isLoading ? null : onTap,
        child: Container(
          height: height,
          padding: padding,
          child: CustomPaint(
            painter: _DashedBorderPainter(
              color: borderColor,
              borderRadius: borderRadius,
            ),
            child: isLoading
                ? Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            semanticsValue: "Memuat",
                            valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Memuat...",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: color),
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: TextStyle(
                              color: color, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Painter untuk membuat border putus-putus
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double dashWidth = 5;
  final double dashSpace = 5;
  final double borderRadius;

  _DashedBorderPainter({
    required this.color,
    this.borderRadius = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius)));

    final dashPath = Path();
    double distance = 0;
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      while (distance < metric.length) {
        final next = distance + dashWidth;
        dashPath.addPath(metric.extractPath(distance, next), Offset.zero);
        distance = next + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
