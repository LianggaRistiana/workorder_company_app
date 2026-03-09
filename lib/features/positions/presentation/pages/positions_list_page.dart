import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/positions_permission.dart';
import 'package:workorder_company_app/core/authorization/widget/permission_gate.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_event.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
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
                      final result = await context
                          .push<PositionEntity>(AppRoutes.positionsCreate);

                      if (!context.mounted) return;

                      if (result != null) {
                        context
                            .read<PositionsListBloc>()
                            .add(NewPositionAdded(result));
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
