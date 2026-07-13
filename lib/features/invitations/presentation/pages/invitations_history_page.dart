import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workorder_company_app/core/authorization/feature/invitation_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/history_invitations_list/history_invitations_list_bloc.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/history_invitations_list/history_invitations_list_event.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/history_invitations_list/history_invitations_list_state.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/sender_actions/sender_invitation_actions_cubit.dart';
import 'package:workorder_company_app/features/invitations/presentation/widgets/sender_invitation_card.dart';
import 'package:workorder_company_app/features/invitations/presentation/widgets/sender_invitation_action.dart';
import 'package:workorder_company_app/features/invitations/presentation/widgets/sender_invitation_detail.dart';
import 'package:workorder_company_app/features/invitations/presentation/widgets/user_summary_view.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_cubit.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class InvitationsHistoryPage extends StatelessWidget {
  const InvitationsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => sl<HistoryInvitationsListBloc>()
              ..add(const GetHistoryInvitationsList())),
        BlocProvider(create: (_) => sl<SenderInvitationActionsCubit>()),
      ],
      child:
          BlocConsumer<HistoryInvitationsListBloc, HistoryInvitationsListState>(
        listener: (context, state) {
          if (state.status == HistoryInvitationsListStatus.error &&
              state.invitations.isNotEmpty) {
            context.showError(state.errorMessage ?? 'Terjadi kesalahan');
          }
          if (state.status == HistoryInvitationsListStatus.loaded) {
            context.read<NotificationLogCubit>().markAsRead(
                  null,
                  ResourceType.invitation,
                );
          }
        },
        builder: (context, state) {
          return InvitationsHistoryView(
            state: state,
            onRefresh: () {
              context
                  .read<HistoryInvitationsListBloc>()
                  .add(const GetHistoryInvitationsList());
            },
          );
        },
      ),
    );
  }
}

class InvitationsHistoryView extends StatelessWidget {
  final HistoryInvitationsListState state;
  final VoidCallback onRefresh;

  const InvitationsHistoryView({
    super.key,
    required this.state,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ListPageScaffold(
      title: "Riwayat Undangan",

      /// LOADING
      isLoading: state.status == HistoryInvitationsListStatus.loading,

      /// ERROR MESSAGE (only when no data)
      errorMessage: state.status == HistoryInvitationsListStatus.error
          ? state.errorMessage
          : null,

      /// ITEMS
      items: state.invitations,

      /// REFRESH
      onRefresh: () async => onRefresh(),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.employeeInvite);
        },
        label: const Text('Buat Undangan'),
        icon: const Icon(LucideIcons.mail),
      ).require(roleCan(InvitationPermission.create)),

      /// ITEM BUILDER
      itemBuilder: (invitation) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InvitationCard(
            invitation: invitation,
            onTap: () {
              showAppBottomSheet(
                context,
                header: invitation.toUser != null
                    ? UserSummaryView(user: invitation.toUser!)
                    : null,
                content: SenderInvitationDetail(invitation: invitation),
                footer: BlocProvider.value(
                    value: context.read<SenderInvitationActionsCubit>(),
                    child: SenderInvitationAction(
                      invitation: invitation,
                    ).require(
                      roleCan(InvitationPermission.cancel),
                      fallback: FilledButton(
                        onPressed: () => context.pop(),
                        child: const Text("Tutup"),
                      ),
                    )),
              );
            },
          ),
        );
      },

      /// EMPTY
      emptyWidget: const Text("Belum ada riwayat undangan"),

      loadingMessage: "Memuat riwayat undangan...",
    );
  }
}
