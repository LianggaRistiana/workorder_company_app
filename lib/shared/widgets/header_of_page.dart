import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

// TODO : refactor all page that has kind of this widget
class HeaderOfPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const HeaderOfPage({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconBox(icon: icon),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
