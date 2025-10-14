import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/positions_bloc.dart';
import 'package:workorder_company_app/shared/widgets/select_buttom_sheet.dart';

// class PositionsSelector extends StatelessWidget {
//   const PositionsSelector({
//     super.key,
//     required this.selectedPositions,
//     required this.onAdd,
//     required this.onRemove,
//     this.itemBuilder,
//   });

//   /// Daftar posisi yang dipilih
//   final List<PositionEntity> selectedPositions;

//   /// Callback ketika posisi ditambahkan
//   final void Function(PositionEntity) onAdd;

//   /// Callback ketika posisi dihapus
//   final void Function(PositionEntity) onRemove;

//   /// Opsional: builder custom untuk menampilkan tiap item posisi
//   final Widget Function(PositionEntity position)? itemBuilder;

//   Future<void> _openPositionSelector(
//     BuildContext context,
//     List<PositionEntity> positions,
//     bool isLoading,
//   ) async {
//     if (isLoading) return;

//     final position = await showModalBottomSheet<PositionEntity>(
//       context: context,
//       isScrollControlled: true,
//       builder: (_) => SelectBottomSheet<PositionEntity>(
//         title: 'Pilih Posisi',
//         items: positions,
//         itemLabel: (p) => p.name,
//         isLoading: isLoading,
//         onSelect: (selected) => Navigator.pop(context, selected),
//       ),
//     );

//     if (position != null &&
//         !selectedPositions.any((pos) => pos.id == position.id)) {
//       onAdd(position);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<PositionsBloc, PositionsState>(
//       builder: (context, state) {
//         final isLoading = state is PositionsLoading;
//         final positions =
//             state is PositionsLoaded ? state.positions : <PositionEntity>[];

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   "Posisi",
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//                 const Spacer(),
//                 OutlinedButton.icon(
//                   icon: const Icon(Icons.add),
//                   label: isLoading
//                       ? const SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : const Text('Tambah Posisi'),
//                   onPressed: isLoading
//                       ? null
//                       : () =>
//                           _openPositionSelector(context, positions, isLoading),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             if (selectedPositions.isEmpty)
//               const Text('Belum ada posisi yang dipilih')
//             else
//               ListView.separated(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: selectedPositions.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 2),
//                 itemBuilder: (context, index) {
//                   final position = selectedPositions[index];
//                   if (itemBuilder != null) {
//                     // Gunakan builder custom jika disediakan
//                     return itemBuilder!(position);
//                   }
//                   // Default tampilan (tanpa min/max)
//                   return CustomCard(
//                     margin: const EdgeInsets.symmetric(vertical: 0),
//                     padding: const EdgeInsets.only(right: 4, left: 12),
//                     elevation: 0,
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             position.name,
//                             style: Theme.of(context).textTheme.bodyMedium,
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.close),
//                           onPressed: () => onRemove(position),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//           ],
//         );
//       },
//     );
//   }
// }

class PositionsSelector extends StatelessWidget {
  const PositionsSelector({
    super.key,
    required this.selectedPositions,
    required this.onAdd,
    this.positions, // optional kalau pakai direct data
    this.useBloc = true, // default ambil dari bloc
  });

  final List<PositionEntity> selectedPositions;
  final void Function(PositionEntity) onAdd;
  final List<PositionEntity>? positions;
  final bool useBloc;

  Future<void> _openPositionSelector(
    BuildContext context,
    List<PositionEntity> availablePositions,
    bool isLoading,
  ) async {
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
    if (useBloc) {
      return BlocBuilder<PositionsBloc, PositionsState>(
        builder: (context, state) {
          final isLoading = state is PositionsLoading;
          final availablePositions =
              state is PositionsLoaded ? state.positions : <PositionEntity>[];
          return _buildButton(context, availablePositions, isLoading);
        },
      );
    } else {
      final availablePositions = positions ?? [];
      return _buildButton(context, availablePositions, false);
    }
  }

  Widget _buildButton(BuildContext context, List<PositionEntity> availablePositions, bool isLoading) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.add),
      label: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('Tambah Posisi'),
      onPressed: isLoading
          ? null
          : () => _openPositionSelector(context, availablePositions, isLoading),
    );
  }
}

