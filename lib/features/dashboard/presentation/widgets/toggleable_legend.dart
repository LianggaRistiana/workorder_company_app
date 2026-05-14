import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/donut_data_entity.dart';
import 'package:workorder_company_app/shared/utils/format_value.dart';

class ToggleableLegend extends StatefulWidget {
  final List<DonutDataEntity> data;

  const ToggleableLegend({
    super.key,
    required this.data,
  });

  @override
  State<ToggleableLegend> createState() => _ToggleableLegendState();
}

class _ToggleableLegendState extends State<ToggleableLegend> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme.titleSmall;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Keterangan",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.arrow_downward),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState:
              isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Wrap(
                spacing: 14,
                runSpacing: 8,
                children: widget.data.map((item) {
                  return SizedBox(
                    width: 140,
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: item.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.label,
                            style: textTheme,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formatValue(item.value),
                          style: textTheme?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )),
          secondChild: const SizedBox.shrink(),
        ),
      ],
    );
  }
}
