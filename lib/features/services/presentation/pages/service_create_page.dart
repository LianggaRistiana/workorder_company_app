import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/list/forms_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_event.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/create/service_create_cubit.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/create/service_create_state.dart';
import 'package:workorder_company_app/features/services/presentation/pages/service_editor_view.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

class ServiceCreatePage extends StatelessWidget {
  const ServiceCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ServiceCreateCubit>(),
        ),
        BlocProvider(
          create: (_) =>
              sl<PositionsListBloc>()..add(GetPositionsListRequested()),
        ),
        BlocProvider(
          create: (_) => sl<FormsListBloc>()..add(GetFormsListRequested()),
        )
      ],
      child: BlocConsumer<ServiceCreateCubit, ServiceCreateState>(
        listener: (context, state) {
          if (state.status == ServiceCreateStatus.error) {
            context.showError(
              state.errorMessage ?? "Terjadi Kesalahan",
            );
          }

          if (state.status == ServiceCreateStatus.success) {
            context.showSuccess("Berhasil Menyimpan Layanan Baru");
            context.pop();
          }
        },
        builder: (context, state) {
          return ServiceEditorView.create(
            isLoading: state.status == ServiceCreateStatus.loading,
            initialEntity: null,
            onSubmit: (draft) {
              return context.read<ServiceCreateCubit>().submit(draft);
            },
          );
        },
      ),
    );
  }
}
