import 'package:flutter/material.dart';

class LoadingStateInline extends StatelessWidget {
  final bool isEndAlign;

  const LoadingStateInline({super.key, this.isEndAlign = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          isEndAlign ? MainAxisAlignment.end : MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Container(
            padding: const EdgeInsets.all(4),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          'Memuat...',
          // style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
