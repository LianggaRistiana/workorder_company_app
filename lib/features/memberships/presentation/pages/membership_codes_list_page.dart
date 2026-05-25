import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/code_list/membership_code_list_bloc.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/code_list/membership_code_list_event.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/code_list/membership_code_list_state.dart';
import 'package:workorder_company_app/features/memberships/presentation/bloc/generate_code/generate_membership_code_cubit.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/item_tile_lined.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class MembershipCodesListPage extends StatelessWidget {
  const MembershipCodesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MembershipCodeListBloc>(
          create: (_) => sl<MembershipCodeListBloc>()
            ..add(GetMembershipCodeListRequested()),
        ),
        BlocProvider<GenerateMembershipCodeCubit>(
          create: (_) => sl<GenerateMembershipCodeCubit>(),
        ),
      ],
      child: const _MembershipCodesListView(),
    );
  }
}

class _MembershipCodesListView extends StatelessWidget {
  const _MembershipCodesListView();

  Future<void> _onRefresh(BuildContext context) async {
    context
        .read<MembershipCodeListBloc>()
        .add(GetMembershipCodeListRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MembershipCodeListBloc, MembershipCodeListState>(
        listener: (context, state) {
      if (state.status == MemberShipCodeListStatus.error) {
        context.showError(state.errorMessage ?? "Terjadi Kesalahan");
      }
    }, builder: (context, state) {
      final isLoading = state.status == MemberShipCodeListStatus.loading;
      final items = state.codes;

      return ListPageScaffold(
        title: "Kode Langganan",
        isLoading: isLoading,
        items: items,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push(AppRoutes.uploadMemberCode);
          },
          child: const Icon(AppIcon.add),
        ),
        header: _InfoToConfig(),
        errorMessage: state.errorMessage,
        onRefresh: () => _onRefresh(context),
        loadingMessage: "Memuat Kode Langganan...",
        emptyWidget: EmptyStateWidget(
          text: "Tidak ada kode langganan",
        ),
        itemBuilder: (item) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ItemTileLined(child: Text(item.code)),
        ),
      );
    });
  }
}

class _InfoToConfig extends StatelessWidget {
  const _InfoToConfig();

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        InformationBlock(
          message:
              "Pastikan Integrasi sistem aktif dan dalam mode klaim kode, agar kustomer anda dapat menautkan akun mereka ke sistem kami melalui token anda",
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          iconAlignment: IconAlignment.end,
          icon: const Icon(AppIcon.next),
          label: const Text("Konfigurasi"),
          onPressed: () {
            context.push(AppRoutes.systemIntegrationConfig);
          },
        ),
      ]),
    );
  }
}
