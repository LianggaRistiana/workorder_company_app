import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/shared/widgets/select_buttom_sheet.dart';


class PositionsSelector extends StatelessWidget {
  const PositionsSelector({
    super.key,
    required this.selectedPositions,
    required this.availablePositions,
    required this.onAdd,
    required this.buttonBuilder,
    this.isLoading = false,
  });

  final List<PositionEntity> selectedPositions;
  final List<PositionEntity> availablePositions;
  final void Function(PositionEntity) onAdd;
  final bool isLoading;

  final Widget Function(
    BuildContext context,
    VoidCallback onPressed,
    bool isLoading,
  ) buttonBuilder;

  Future<void> _openPositionSelector(BuildContext context) async {
    if (isLoading) return;

    final position = await showModalBottomSheet<PositionEntity>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SelectBottomSheet<PositionEntity>(
        title: 'Pilih Posisi',
        items: availablePositions,
        itemLabel: (p) => p.name,
        isLoading: isLoading,
        onSelect: (selected) => Navigator.pop(context, selected),
      ),
    );

    if (position != null &&
        !selectedPositions.any((p) => p.id == position.id)) {
      onAdd(position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return buttonBuilder(
      context,
      () => _openPositionSelector(context),
      isLoading,
    );
  }
}