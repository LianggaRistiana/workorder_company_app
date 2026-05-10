import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/authorization/feature/service_request_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/work_order_permission.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_company_get_cubit.dart';
import 'package:workorder_company_app/features/dashboard/presentation/bloc/service_request_stat/service_request_stats_cubit.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_active_cubit.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_cubit.dart';
import 'package:workorder_company_app/features/submissions/presentation/cubit/file_upload_progress_cubit.dart';

class AuthenticatedBlocProvider extends StatelessWidget {
  final UserRole role;
  final Widget child;
  const AuthenticatedBlocProvider({
    super.key,
    required this.role,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationLogCubit>(
          create: (_) => sl<NotificationLogCubit>()..fetchLogs(),
        ),
        BlocProvider<NotificationActiveCubit>(
          create: (_) => sl<NotificationActiveCubit>()..checkStatus(),
        ),
        BlocProvider<InternalGetCompanyCubit>(
            create: (_) => sl<InternalGetCompanyCubit>()),
        BlocProvider<FileUploadProgressCubit>(
            create: (_) => sl<FileUploadProgressCubit>()),

        // DashBoard
        if (role.canPermission(ServiceRequestPermission.view)) ...[
          BlocProvider<ServiceRequestStatsCubit>(
              create: (_) => sl<ServiceRequestStatsCubit>()),
        ],
        if (role.canPermission(WorkOrderPermissions.view)) ...[
          // TODO: WO STAT CUBIT
        ]
      ],
      child: child,
    );
  }
}
