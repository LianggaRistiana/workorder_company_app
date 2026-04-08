import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const SectionTitle(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: style ?? Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
