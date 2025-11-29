import 'package:flutter/material.dart';

class StaffQuotaChip extends StatelessWidget {
  final int currentCount;
  final int min;
  final int max;

  const StaffQuotaChip({
    super.key,
    required this.currentCount,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    if (currentCount < min) {
      icon = Icons.warning_amber_rounded; // kurang
      color = Colors.orange;
    } else if (currentCount > max) {
      icon = Icons.close_rounded; // lebih
      color = Colors.red;
    } else {
      icon = Icons.check_circle_rounded; // penuh / sesuai
      color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$currentCount Pegawai",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (min == max)
                    Text(
                      "Kuota $min Pegawai",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: color,
                          ),
                    ),
                  if (min != max)
                    Text(
                      "Kuota $min - $max Pegawai",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: color,
                          ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}
