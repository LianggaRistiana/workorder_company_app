import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_cubit.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

class GeneralListener extends StatelessWidget {
  final Widget child;
  const GeneralListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NotificationLogCubit, NotificationLogState>(
            listener: (context, state) {
          if (state.status == NotificationLogStatus.error) {
            context.showError(state.errorMessage ??
                "Terjadi kesalahan saat mengambil data notifikasi");
          }
        })
        // TODO : add notification logs listener here
        // TODO : add notification active status listener here
      ],
      child: child,
    );
  }
}
