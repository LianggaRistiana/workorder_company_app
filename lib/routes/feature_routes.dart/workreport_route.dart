import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/workreport/presentation/bloc/get_work_report_cubit.dart';
import 'package:workorder_company_app/features/workreport/presentation/pages/workreport_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final workreportRouter = [
  // TODO : make wrapper for this feature to inject bloc
  GoRoute(
    path: AppRoutes.workreports,
    builder: (_, state) {
      final id = state.pathParameters['id']!;
      return BlocProvider(
          create: (_) => sl<GetWorkReportCubit>(),
          child: WorkreportPage(
            workorderId: id,
          ));
    },
  )
];
