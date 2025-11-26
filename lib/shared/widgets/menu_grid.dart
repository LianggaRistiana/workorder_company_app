import 'package:flutter/material.dart';

class MenuGrid extends StatelessWidget {
  final List<Widget> items;
  const MenuGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 0.78,
      children: items,
    );
  }
}
