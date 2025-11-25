import 'package:flutter/material.dart';

class ClientNameChip extends StatelessWidget {
  final String name;

  const ClientNameChip({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircleAvatar(
          radius: 12,
          child: Icon(Icons.person_2_rounded, size: 16),
        ),
        const SizedBox(width: 8),
        Text(name),
      ]
    );
  }
}