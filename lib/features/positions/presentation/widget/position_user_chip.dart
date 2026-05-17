import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/positions/domain/usecase/get_current_user_positions_usecase.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class PositionUserChip extends StatelessWidget {
  const PositionUserChip({super.key});

  @override
  Widget build(BuildContext context) {
    final position = sl<GetCurrentUserPositionsUsecase>().call();

    return position == null
        ? const SizedBox.shrink()
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                IconBox.small(
                  icon: AppIcon.department,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    position.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                  ),
                ),
              ],
            ),
          );
  }
}
