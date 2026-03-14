import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/history_invitations_list/history_invitations_list_bloc.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/history_invitations_list/history_invitations_list_event.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/history_invitations_list/history_invitations_list_state.dart';
import 'package:workorder_company_app/features/invitations/presentation/widgets/invitation_card.dart';
import 'package:workorder_company_app/features/invitations/presentation/widgets/sender_invitation_detail.dart';
import 'package:workorder_company_app/features/invitations/presentation/widgets/user_summary_view.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/info_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class InvitationsHistoryPage extends StatelessWidget {
  const InvitationsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HistoryInvitationsListBloc>()
        ..add(const GetHistoryInvitationsList()),
      child:
          BlocConsumer<HistoryInvitationsListBloc, HistoryInvitationsListState>(
        listener: (context, state) {
          if (state.status == HistoryInvitationsListStatus.error &&
              state.invitations.isNotEmpty) {
            context.showError(state.errorMessage ?? 'Terjadi kesalahan');
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

      /// ITEM BUILDER
      itemBuilder: (invitation) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InvitationCard(
            invitation: invitation,
            onTap: () {
              showAppBottomSheet(context,
                  header: Row(
                    children: [
                      IconBox(icon: Icons.email_outlined),
                      const SizedBox(width: 16),
                      Expanded(child: UserSummaryView(user: invitation.toUser))
                    ],
                  ),
                  content: SenderInvitationDetail(invitation: invitation),
                  footer:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      child: const Text("Tutup"),
                    ),
                    const SizedBox(width: 16),
                    FilledButton(
                      onPressed: () {
                        // TODO: Implement cancel invitation
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Batalkan Undangan"),
                    )
                  ]));
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
