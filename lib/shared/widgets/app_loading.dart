import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  final String message;
  final double spinnerSize;
  final double spacing;

  const AppLoading({
    super.key,
    this.message = 'Memuat...',
    this.spinnerSize = 32,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: spinnerSize,
          height: spinnerSize,
          child: CircularProgressIndicator(
            strokeWidth: 1,
            valueColor: AlwaysStoppedAnimation(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        SizedBox(height: spacing),
        Text(
          message,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
