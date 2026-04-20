import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/presentation/bloc/get_work_report_cubit.dart';

class WorkReportPage extends StatelessWidget {
  final WorkOrderEntity workOrder;
  const WorkReportPage({
    super.key,
    required this.workOrder,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<GetWorkReportCubit>()..getWorkReport(workOrder.id),
        ),
        // BlocProvider(
        //   create: (context) => WorkReportBloc(),
        // ),
      ],
      child: Scaffold(),
    );
  }
}
