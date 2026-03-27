import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/positions_permission.dart';
import 'package:workorder_company_app/core/authorization/widget/permission_gate.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_event.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
// import 'package:workorder_company_app/shared/widgets/bottom_sheet_actions.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
// import 'package:workorder_company_app/shared/widgets/info_bottom_sheet.dart';
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
    context
        .read<PositionsListBloc>()
        .add(GetPositionsListRequested(forceRefresh: true));
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
                      final result = await context
                          .push<PositionEntity>(AppRoutes.positionsCreate);

                      if (!context.mounted) return;

                      if (result != null) {
                        context
                            .read<PositionsListBloc>()
                            .add(GetPositionsListRequested());
                      }
                    },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Departemen'),
            ),
          ),
          itemBuilder: (position) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ClickableCustomCard(
              margin: EdgeInsets.zero,
              onTap: () {
                context.push(AppRoutes.positionsDetail.fillId(position.id));
              },
              onLongPress: () {
                // TODO : fix later
                // showAppBottomSheet(
                //   context,
                //   header: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         IconBox(
                //           icon: AppIcon.department,
                //         ),
                //         const SizedBox(width: 12),
                //         Expanded(
                //           child: Text(
                //             position.name,
                //             maxLines: 1,
                //             overflow: TextOverflow.ellipsis,
                //             style: Theme.of(context).textTheme.titleMedium,
                //           ),
                //         ),
                //       ]),
                //   content: ActionBottomSheetContent(
                //     actions: [
                //       BottomSheetAction(
                //         title: "Edit",
                //         icon: AppIcon.edit,
                //         onTap: () {
                //           // print("Edit");
                //         },
                //       ),
                //       BottomSheetAction(
                //         title: "Hapus",
                //         icon: AppIcon.delete,
                //         isDanger: true,
                //         onTap: () {
                //           // print("Delete");
                //         },
                //       ),
                //     ],
                //   ),
                // );
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconBox(
                      icon: AppIcon.department,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        position.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}
