import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/member_list/member_list_bloc.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/member_list/member_list_event.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/member_list/member_list_state.dart';
import 'package:workorder_company_app/features/memberships/presentation/widgets/member_item_card.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class MemberListPage extends StatelessWidget {
  const MemberListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<MemberListBloc>()..add(GetMemberListRequested()),
        child: const _MemberListView());
  }
}

class _MemberListView extends StatelessWidget {
  const _MemberListView();

  Future<void> _onRefresh(BuildContext context) async {
    context.read<MemberListBloc>().add(GetMemberListRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MemberListBloc, MemberListState>(
        listener: (context, state) {
      if (state.status == MemberListStatus.error) {
        context.showError(state.errorMessage ?? "Terjadi Kesalahan");
      }
    }, builder: (context, state) {
      return ListPageScaffold(
          title: "Pelanggan",
          isLoading: state.status == MemberListStatus.loading,
          errorMessage: state.errorMessage,
          items: state.members,
          onRefresh: () => _onRefresh(context),
          loadingMessage: "Memuat Pelanggan...",
          itemBuilder: (member) => MemberItemCard(member: member));
    });
  }
}
