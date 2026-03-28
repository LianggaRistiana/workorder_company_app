import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/authorization/feature/invitation_permission.dart';
import 'package:workorder_company_app/core/authorization/widget/permission_gate.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/pending_invitations_list/pending_invitations_list_bloc.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/pending_invitations_list/pending_invitations_list_event.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/pending_invitations_list/pending_invitations_list_state.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/receiver_actions/receiver_invitation_actions_cubit.dart';
import 'package:workorder_company_app/features/invitations/presentation/widgets/receiver_invitation_action.dart';
import 'package:workorder_company_app/features/invitations/presentation/widgets/receiver_invitation_card.dart';
import 'package:workorder_company_app/features/invitations/presentation/widgets/receiver_invitation_detail.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/info_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class ReceiverInvitationsPage extends StatelessWidget {
  const ReceiverInvitationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => sl<PendingInvitationsListBloc>()
              ..add(GetPendingInvitationsList())),
        BlocProvider(create: (_) => sl<ReceiverInvitationActionsCubit>()),
      ],
      child:
          BlocConsumer<PendingInvitationsListBloc, PendingInvitationsListState>(
        listener: (context, state) {
          if (state.status == PendingInvitationsListStatus.error &&
              state.invitations.isNotEmpty) {
            context.showError(state.errorMessage ?? 'Terjadi kesalahan');
          }
        },
        builder: (context, state) {
          return _PendingInvitationsListView(
            state: state,
            onRefresh: () {
              context
                  .read<PendingInvitationsListBloc>()
                  .add(const GetPendingInvitationsList());
            },
          );
        },
      ),
    );
  }
}

class _PendingInvitationsListView extends StatelessWidget {
  final PendingInvitationsListState state;
  final VoidCallback onRefresh;
  const _PendingInvitationsListView(
      {required this.state, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return ListPageScaffold(
      title: "Undangan Masuk",
      isLoading: state.status == PendingInvitationsListStatus.loading,
      errorMessage: state.status == PendingInvitationsListStatus.error
          ? state.errorMessage
          : null,
      items: state.invitations,
      onRefresh: () async => onRefresh(),
      itemBuilder: (invitation) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ReceiverInvitationCard(
            invitation: invitation,
            onTap: () {
              showAppBottomSheet(context,
                  header: Row(
                    children: [
                      IconBox(icon: Icons.home_work_outlined),
                      const SizedBox(width: 16),
                      Expanded(child: Text(invitation.company?.name ?? ""))
                    ],
                  ),
                  content: ReceiverInvitationDetail(invitation: invitation),
                  // TODO : Permission for receiver change to action rather than reject and accept
                  footer: BlocProvider.value(
                      value: context.read<ReceiverInvitationActionsCubit>(),
                      child: PermissionGate(
                          permission: InvitationPermission.receiverView,
                          child: ReceiverInvitationAction(
                              invitation: invitation))));
            },
          ),
        );
      },
      emptyWidget: const Text("Belum ada undangan masuk"),
      loadingMessage: "Memuat undangan masuk...",
    );
  }
}
