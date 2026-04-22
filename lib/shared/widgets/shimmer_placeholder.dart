import 'package:flutter/material.dart';

class ShimmerPlaceholder extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const ShimmerPlaceholder({
    super.key,
    required this.height,
    required this.width,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
