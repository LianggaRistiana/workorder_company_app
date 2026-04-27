import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/list/forms_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_event.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/update/service_update_cubit.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/update/service_update_state.dart';
import 'package:workorder_company_app/features/services/presentation/pages/service_editor_view.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

class ServiceUpdatePage extends StatelessWidget {
  final ServiceEntity serviceIntialData;
  const ServiceUpdatePage({super.key, required this.serviceIntialData});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ServiceUpdateCubit>(),
        ),
        BlocProvider(
          create: (_) =>
              sl<PositionsListBloc>()..add(GetPositionsListRequested()),
        ),
        BlocProvider(
          create: (_) => sl<FormsListBloc>()..add(GetFormsListRequested()),
        )
      ],
      child: BlocConsumer<ServiceUpdateCubit, ServiceUpdateState>(
        listener: (context, state) {
          if (state.status == ServiceUpdateStatus.error) {
            context.showError(
              state.errorMessage ?? "Terjadi Kesalahan",
            );
          }

          if (state.status == ServiceUpdateStatus.success) {
            context.showSuccess("Berhasil Memperbarui Layanan");
            context.pop();
          }
        },
        builder: (context, state) {
          return ServiceEditorView.update(
            isLoading: state.status == ServiceUpdateStatus.loading,
            initialEntity: serviceIntialData,
            onSubmit: (draft) {
              return context.read<ServiceUpdateCubit>().submit(draft);
            },
          );
        },
      ),
    );
  }
}
