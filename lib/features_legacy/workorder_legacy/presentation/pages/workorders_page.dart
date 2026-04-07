import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/workorder_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/presentation/bloc/workorder_bloc.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/presentation/widgets/workorder_item.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class WorkordersPage extends StatefulWidget {
  const WorkordersPage({super.key});

  @override
  State<WorkordersPage> createState() => _WorkordersPageState();
}

class _WorkordersPageState extends State<WorkordersPage> {
  @override
  void initState() {
    super.initState();
    context.read<WorkorderBloc>().add(GetWorkordersRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkorderBloc, WorkorderState>(
      builder: (context, state) {
        return ListPageScaffold(
          title: "Perintah Kerja",
          isLoading: state.status == WorkorderStateStatus.loading,
          errorMessage: state.errorMessage,
          items: state.workorders,
          loadingMessage: "Memuat perintah kerja...",

          // 🔄 Refresh
          onRefresh: () async {
            context.read<WorkorderBloc>().add(GetWorkordersRequested());
          },

          // 🔎 Search bar tetap ada
          bottomAppBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
              ),
              child: CustomInputField(
                label: "Cari Perintah Kerja",
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),

          // 🔘 FAB
          floatingActionButton: FloatingActionButton.extended(
            onPressed:
                state.status == WorkorderStateStatus.loading ? null : () {},
            label: const Text("Tambah Perintah Kerja"),
            icon: const Icon(Icons.add),
          ).require(roleCan(WorkOrderPermissions.create)),

          // 🏷 Header atas list
          header: HorizontalButton(
            margin: const EdgeInsets.all(AppSpacing.md),
            title: "Riwayat Workorder",
            description: "Lihat Workorder yang dibatalkan dan telah selesai",
            leadingIcon: Icons.history,
            onTap: () {},
          ),

          // 📦 Item builder
          itemBuilder: (item) => WorkorderItem(
            workorder: item,
            onTap: () async {
              final result = await context.push(
                AppRoutes.workordersDetail.fillId(item.id),
              );

              if (!context.mounted) return;

              if (result == true) {
                context.read<WorkorderBloc>().add(GetWorkordersRequested());
              }
            },
          ),
        );
      },
    );
  }
}
