import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/authorization/feature/positions_permission.dart';
import 'package:workorder_company_app/core/authorization/widget/permission_gate.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_event.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_state.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/add_position_widget.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class PositionsListPage extends StatelessWidget {
  const PositionsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PositionsListBloc>()..add(GetPositionsListRequested()),
      child: const _PositionsListView(),
    );
  }
}

class _PositionsListView extends StatelessWidget {
  const _PositionsListView();

  Future<void> _onRefresh(BuildContext context) async {
    context.read<PositionsListBloc>().add(GetPositionsListRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PositionsListBloc, PositionsListState>(
      builder: (context, state) {
        final isLoading = state.status == PositionsListStatus.loading;

        final errorMessage = state.errorMessage;

        final positions = state.positions;

        return ListPageScaffold(
          title: "Departemen",
          isLoading: isLoading,
          errorMessage: errorMessage,
          items: positions,
          loadingMessage: "Memuat Departemen...",
          onRefresh: () => _onRefresh(context),
          emptyWidget: const Text(
            "Belum ada Departemen.",
            style: TextStyle(color: Colors.grey),
          ),
          floatingActionButton: PermissionGate(
            permission: PositionsPermission.create,
            child: FloatingActionButton.extended(
              onPressed: isLoading
                  ? null
                  : () async {
                      final result = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (_) => const AddPositionBottomSheet(),
                      );

                      if (result != null && context.mounted) {
                        // TODO: dispatch event add position
                        // context.read<PositionsBloc>().add(
                        //   AddPositionRequested(result),
                        // );
                      }
                    },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Departemen'),
            ),
          ),
          itemBuilder: (position) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: CustomCard(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.badge_outlined,
                    size: 28,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(
                  position.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
                onTap: () {
                  // TODO: navigate to detail/edit
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
// class PositionsListPage extends StatelessWidget {
//   const PositionsListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => sl<PositionsBloc>()..add(GetPositionsRequested()),
//       child: const _PositionsView(),
//     );
//   }
// }

// class _PositionsView extends StatelessWidget {
//   const _PositionsView();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Departemen Pegawai'),
//         leading: CustomBackButton()
//       ),
//       body: BlocBuilder<PositionsBloc, PositionsState>(
//         builder: (context, state) {
//           if (state is PositionsLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is PositionsLoaded) {
//             final positions = state.positions;

//             if (positions.isEmpty) {
//               return const Center(
//                 child: Text(
//                   'Belum ada Departemen.',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               );
//             }

//             return Stack(
//               children: [
//                 ListView.separated(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: positions.length,
//                   separatorBuilder: (_, __) => const SizedBox(height: 8),
//                   itemBuilder: (context, index) {
//                     final position = positions[index];
//                     return CustomCard(
//                       margin: const EdgeInsets.all(0),
//                       padding: const EdgeInsets.all(0),
//                       child: ListTile(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 12,
//                         ),
//                         leading: Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color:
//                                 Theme.of(context).colorScheme.primaryContainer,
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Icon(
//                             Icons.badge_outlined,
//                             size: 28,
//                             color: Theme.of(context).colorScheme.primary,
//                           ),
//                         ),
//                         title: Text(
//                           position.name,
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleMedium
//                               ?.copyWith(fontWeight: FontWeight.bold),
//                         ),
//                         trailing: const Icon(
//                           Icons.chevron_right,
//                           color: Colors.grey,
//                         ),
//                         onTap: () {
//                           // TODO: nanti arahkan ke detail/edit Departemen
//                         },
//                       ),
//                     );
//                   },
//                 ),
//                 if (state is PositionsLoading)
//                   Container(
//                     color: Colors.black26,
//                     child: const Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   ),
//               ],
//             );
//           }

//           if (state is PositionsError) {
//             return Center(
//               child: Text(
//                 state.message,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             );
//           }

//           return const SizedBox.shrink();
//         },
//       ),
//       floatingActionButton: PermissionGate(
//           permission: PositionsPermission.create,
//           child: FloatingActionButton.extended(
//             onPressed: () async {
//               final result = await showModalBottomSheet<String>(
//                 context: context,
//                 isScrollControlled: true,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                 ),
//                 builder: (_) => const AddPositionBottomSheet(),
//               );

//               if (result != null) {
//                 // TODO: handle hasilnya
//                 // context.read<PositionsBloc>().add(AddPositionRequested(result));
//               }
//             },
//             icon: const Icon(Icons.add),
//             label: const Text('Tambah Departemen'),
//           )),
//     );
//   }
// }
