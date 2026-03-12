import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/history_invitations_list/history_invitations_list_bloc.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/history_invitations_list/history_invitations_list_event.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/history_invitations_list/history_invitations_list_state.dart';
import 'package:workorder_company_app/features/invitations/presentation/widgets/invitation_card.dart';

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
          if (state.status == HistoryInvitationsListStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Terjadi kesalahan',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return InvitationsHistoryView(state: state);
        },
      ),
    );
  }
}

class InvitationsHistoryView extends StatelessWidget {
  final HistoryInvitationsListState state;

  const InvitationsHistoryView({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Undangan")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (state.status) {
      case HistoryInvitationsListStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case HistoryInvitationsListStatus.error:
        return const Center(child: Text("Gagal memuat data"));

      case HistoryInvitationsListStatus.loaded:
        if (state.invitations.isEmpty) {
          return const Center(child: Text("Belum ada riwayat undangan"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: state.invitations.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final invitation = state.invitations[index];

            return InvitationCard(
              invitation: invitation,
            );
          },
        );

      case HistoryInvitationsListStatus.initial:
        return const SizedBox();
    }
  }
}
