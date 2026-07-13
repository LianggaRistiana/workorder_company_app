import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_entity.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/actions/invitation_code_action_cubit.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/actions/invitation_code_action_state.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/code_list/invitation_code_list_bloc.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/code_list/invitation_code_list_event.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/code_list/invitation_code_list_state.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/widgets/invitation_code_card.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/widgets/invitation_code_detail_sheet.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/widgets/invitation_code_form_sheet.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_event.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class InvitationCodeListPage extends StatelessWidget {
  const InvitationCodeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InvitationCodeListBloc>(
          create: (_) =>
              sl<InvitationCodeListBloc>()..add(const GetInvitationCodeList()),
        ),
        BlocProvider<InvitationCodeActionCubit>(
          create: (_) => sl<InvitationCodeActionCubit>(),
        ),
        BlocProvider<PositionsListBloc>(
          create: (_) =>
              sl<PositionsListBloc>()..add(GetPositionsListRequested()),
        ),
      ],
      child: const _InvitationCodeListView(),
    );
  }
}

class _InvitationCodeListView extends StatelessWidget {
  const _InvitationCodeListView();

  void _onTap(BuildContext context, InvitationCodeEntity code) {
    showAppBottomSheet(
      context,
      content: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<InvitationCodeActionCubit>()),
          BlocProvider.value(value: context.read<PositionsListBloc>()),
        ],
        child: InvitationCodeDetailSheet(code: code),
      ),
    );
  }

  void _showCreateForm(BuildContext context) {
    showAppBottomSheet(
      context,
      content: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<InvitationCodeActionCubit>()),
          BlocProvider.value(value: context.read<PositionsListBloc>()),
        ],
        child: const InvitationCodeFormSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<InvitationCodeListBloc, InvitationCodeListState>(
          listener: (context, state) {
            if (state.status == InvitationCodeListStatus.error &&
                state.codes.isNotEmpty) {
              context.showError(state.errorMessage ?? 'Terjadi kesalahan');
            }
          },
        ),
        BlocListener<InvitationCodeActionCubit, InvitationCodeActionState>(
          listener: (context, state) {
            if (state.status == InvitationCodeActionStatus.error) {
              context.showError(state.errorMessage ?? 'Terjadi kesalahan');
            }
            if (state.status == InvitationCodeActionStatus.success) {
              final result = state.result;
              final revokedId = state.revokedId;

              if (revokedId != null) {
                context.showSuccess('Kode berhasil dicabut');
                context.read<InvitationCodeListBloc>().add(
                      RemoveInvitationCodeFromList(revokedId),
                    );
                context.pop();
              } else if (result != null) {
                // Check if new or updated
                final existingIds = context
                    .read<InvitationCodeListBloc>()
                    .state
                    .codes
                    .map((c) => c.id)
                    .toList();

                if (existingIds.contains(result.id)) {
                  context.showSuccess('Kode berhasil diperbarui');
                  context.read<InvitationCodeListBloc>().add(
                        UpdateInvitationCodeInList(result),
                      );
                } else {
                  context.showSuccess('Kode berhasil dibuat');
                  context.read<InvitationCodeListBloc>().add(
                        AddInvitationCodeToList(result),
                      );
                }
                context.pop();
              }
            }
          },
        ),
      ],
      child: BlocBuilder<InvitationCodeListBloc, InvitationCodeListState>(
        builder: (context, state) {
          final isLoading =
              state.status == InvitationCodeListStatus.loading;

          return ListPageScaffold(
            title: 'Kode Undangan Pegawai',
            isLoading: isLoading,
            items: state.codes,
            errorMessage:
                state.status == InvitationCodeListStatus.error
                    ? state.errorMessage
                    : null,
            onRefresh: () async {
              context
                  .read<InvitationCodeListBloc>()
                  .add(const GetInvitationCodeList());
            },
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _showCreateForm(context),
              label: const Text('Buat Kode'),
              icon: const Icon(AppIcon.add),
            ),
            emptyWidget: const EmptyStateWidget(
              text: 'Belum ada kode undangan',
            ),
            loadingMessage: 'Memuat kode undangan...',
            itemBuilder: (code) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: InvitationCodeCard(
                code: code,
                onTap: () => _onTap(context, code),
              ),
            ),
          );
        },
      ),
    );
  }
}
