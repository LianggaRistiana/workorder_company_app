import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_company_get_cubit.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_active_cubit.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_cubit.dart';
import 'package:workorder_company_app/features/submissions/presentation/cubit/file_upload_progress_cubit.dart';

class AuthenticatedBlocProvider extends StatelessWidget {
  final Widget child;
  const AuthenticatedBlocProvider({super.key, required this.child});

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
      ],
      child: child,
    );
  }
}
