import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/presentation/bloc/get_work_report_cubit.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/presentation/bloc/submit_work_report_cubit.dart';

class WorkreportWrapper extends StatelessWidget {
  final Widget child;
  const WorkreportWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<GetWorkReportCubit>(),
        ),
        BlocProvider(create: (_) => sl<SubmitWorkReportCubit>()),
      ],
      child: child,
    );
  }
}
