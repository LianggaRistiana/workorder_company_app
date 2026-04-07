import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/workreport_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/presentation/bloc/get_work_report_cubit.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/presentation/bloc/work_report_state.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/presentation/widgets/workreport_main_content.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';

class WorkreportPage extends StatefulWidget {
  final String workorderId;
  const WorkreportPage({super.key, required this.workorderId});

  @override
  State<WorkreportPage> createState() => _WorkreportPageState();
}

class _WorkreportPageState extends State<WorkreportPage> {
  @override
  void initState() {
    super.initState();
    context.read<GetWorkReportCubit>().getWorkReport(widget.workorderId);
  }

  void _refresh() {
    context.read<GetWorkReportCubit>().getWorkReport(widget.workorderId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetWorkReportCubit, WorkReportState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == WorkReportStateStatus.error) {
            context.showError(state.errorMessage ?? "Terjadi kesalahan");
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(onPressed: () {
                context.pop();
              }),
            ),
            body: state.status == WorkReportStateStatus.loading
                ? const Center(child: AppLoading())
                : WorkreportMainContent(
                    workReport: state.workReport,
                  ),
            bottomNavigationBar: FilledButton.icon(
                    label: Text("Isi Formulir Laporan"),
                    onPressed: () async {
                      final result = await context.push(AppRoutes
                          .workreportsSubmit
                          .fillId(widget.workorderId));
                      if (!context.mounted) return;
                      if (result == true) {
                        _refresh();
                      }
                    },
                    icon: Icon(Icons.edit_document))
                .require(
              roleCan(WorkReportPermissions.update),
            ),
          );
        });
  }
}
