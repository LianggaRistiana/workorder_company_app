import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color? backgroundColor;
  final double size;
  final TextStyle? textStyle;

  const EmptyStateWidget({
    super.key,
    this.text = 'Tidak ada item',
    this.icon = Icons.info_outline,
    this.backgroundColor,
    this.size = 50,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              color: backgroundColor ??
                  Theme.of(context).disabledColor.withAlpha(40),
              shape: BoxShape.circle),
          child: Icon(
            icon,
            size: size * 0.5,
            color: Theme.of(context).disabledColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          text,
          style: textStyle ??
              Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).disabledColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
