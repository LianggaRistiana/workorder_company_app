import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/workreport/presentation/bloc/get_work_report_cubit.dart';
import 'package:workorder_company_app/features/workreport/presentation/bloc/work_report_state.dart';
import 'package:workorder_company_app/features/workreport/presentation/widgets/workreport_main_content.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
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
                : WorkreportMainContent(workReport: state.workReport,),
          );
        });
  }
}
