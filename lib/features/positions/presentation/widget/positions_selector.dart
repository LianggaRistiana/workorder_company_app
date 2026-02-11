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

  /// builder untuk tombol
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


// class PositionsSelector extends StatelessWidget {
//   const PositionsSelector({
//     super.key,
//     required this.selectedPositions,
//     required this.onAdd,
//     this.positions, // optional kalau pakai direct data
//     this.useBloc = true, // default ambil dari bloc
//   });

//   final List<PositionEntity> selectedPositions;
//   final void Function(PositionEntity) onAdd;
//   final List<PositionEntity>? positions;
//   final bool useBloc;
//   // final widget

//   Future<void> _openPositionSelector(
//     BuildContext context,
//     List<PositionEntity> availablePositions,
//     bool isLoading,
//   ) async {
//     if (isLoading) return;

//     final position = await showModalBottomSheet<PositionEntity>(
//       context: context,
//       isScrollControlled: true,
//       builder: (_) => SelectBottomSheet<PositionEntity>(
//         title: 'Pilih Posisi',
//         items: availablePositions,
//         itemLabel: (p) => p.name,
//         isLoading: isLoading,
//         onSelect: (selected) => Navigator.pop(context, selected),
//       ),
//     );

//     if (position != null &&
//         !selectedPositions.any((p) => p.id == position.id)) {
//       onAdd(position);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (useBloc) {
//       return BlocBuilder<PositionsBloc, PositionsState>(
//         builder: (context, state) {
//           final isLoading = state is PositionsLoading;
//           final availablePositions =
//               state is PositionsLoaded ? state.positions : <PositionEntity>[];
//           return _buildButton(context, availablePositions, isLoading);
//         },
//       );
//     } else {
//       final availablePositions = positions ?? [];
//       return _buildButton(context, availablePositions, false);
//     }
//   }

//   Widget _buildButton(BuildContext context, List<PositionEntity> availablePositions, bool isLoading) {
//     return TextButton.icon(
//       icon: const Icon(Icons.add),
//       label: isLoading
//           ? const SizedBox(
//               width: 16,
//               height: 16,
//               child: CircularProgressIndicator(strokeWidth: 2),
//             )
//           : const Text('Tambah Posisi'),
//       onPressed: isLoading
//           ? null
//           : () => _openPositionSelector(context, availablePositions, isLoading),
//     );
//   }
// }

