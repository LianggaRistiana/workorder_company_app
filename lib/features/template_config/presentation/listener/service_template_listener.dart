import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/generate_service/generate_service_cubit.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/generate_service/generate_service_state.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/service_template_list/service_template_list_cubit.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/service_template_list/service_template_list_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

class ServiceTemplateListener extends StatelessWidget {
  final Widget child;
  const ServiceTemplateListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ServiceTemplateListCubit, ServiceTemplateListState>(
          listener: (context, state) {
            if (state.status == ServiceTemplateListStatus.error) {
              context.showError(
                  state.errorMessage ?? 'Terjadi kesalahan saat memuat data');
            }
          },
        ),
        BlocListener<GenerateServiceCubit, GenerateServiceState>(
          listener: (context, state) {
            if (state.status == GenerateServiceStatus.error) {
              context.showError(
                  state.errorMessage ?? 'Terjadi kesalahan saat memuat data');
            }
            if (state.isSuccess) {
              context.showSuccess('Berhasil membuat layanan');
              context.go(AppRoutes.companyManageMenu);
            }
          },
        )
      ],
      child: child,
    );
  }
}
