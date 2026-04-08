import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/positions_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_event.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class PositionsListPage extends StatelessWidget {
  const PositionsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PositionsListBloc>()..add(GetPositionsListRequested()),
      child: _PositionsListView(),
    );
  }
}

class _PositionsListView extends StatelessWidget {
  _PositionsListView();
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PositionsListBloc, PositionsListState>(
      listener: (context, state) {
        if (state.status == PositionsListStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi Kesalahan");
        }
      },
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
          onRefresh: () async {
            context
                .read<PositionsListBloc>()
                .add(GetPositionsListRequested(forceRefresh: true));
          },
          emptyWidget: const EmptyStateWidget(
            text: "Tidak ada departemen",
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final result =
                  await context.push<PositionEntity>(AppRoutes.positionsCreate);

              if (!context.mounted) return;

              if (result != null) {
                context
                    .read<PositionsListBloc>()
                    .add(GetPositionsListRequested());
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Tambah Departemen'),
          ).require(roleCan(PositionsPermission.create)),
          itemBuilder: (position) => ClickableCustomCard(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            onTap: () {
              context.push(AppRoutes.positionsDetail.fillId(position.id));
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconBox(
                    isDisabled: !position.isActive,
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
        );
      },
    );
  }
}
