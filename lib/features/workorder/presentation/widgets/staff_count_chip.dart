import 'package:flutter/material.dart';

class StaffCountChip extends StatelessWidget {
  final int staffCount;

  const StaffCountChip({super.key, required this.staffCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        // color: Theme.of(context).primaryColor.withAlpha(50),
        borderRadius: BorderRadius.circular(20), // chip style
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_alt_rounded,
            // color: Theme.of(context).,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            staffCount.toString(),
            style: TextStyle(
              // color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
