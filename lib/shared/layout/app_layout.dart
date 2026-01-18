// TODO : Under Development

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/public_client_service_request/csr_bloc.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_bloc.dart';
import 'package:workorder_company_app/shared/layout/navigation/app_navigantion_bar.dart';

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    if (authState is! Authenticated) {
      return const SizedBox.shrink();
    }

    final role = authState.user.role;

    return MultiBlocProvider(
      // providers: _providersByRole(role),
      providers: [
        BlocProvider(create: (_) => sl<WorkorderBloc>()),
      ],
      child: Scaffold(
        body: child,
        bottomNavigationBar: AppNavigationBar(role: role),
      ),
    );
  }

  List<BlocProvider> _providersByRole(UserRole role) {
    final providers = <BlocProvider>[];

    // Global (all roles)
    // providers.add(
    //   BlocProvider(create: (_) => sl<NotificationBloc>()),
    // );

    switch (role) {
      case UserRole.ownerCompany:
        providers.add(
          BlocProvider(create: (_) => sl<WorkorderBloc>()),
        );
        providers.add(
          BlocProvider(create: (_) => sl<EmployeesBloc>()),
        );
        providers.add(
          BlocProvider(create: (_) => sl<InternalCsrBloc>()),
        );
        // providers.add(
        //   BlocProvider(create: (_) => sl<FormsBloc>()),
        // );
        // providers.add(
        //   BlocProvider(create: (_) => sl<ServicesBloc>()),
        // );
        break;
      case UserRole.managerCompany:
        providers.add(
          BlocProvider(create: (_) => sl<WorkorderBloc>()),
        );
        providers.add(
          BlocProvider(create: (_) => sl<EmployeesBloc>()),
        );
        providers.add(
          BlocProvider(create: (_) => sl<InternalCsrBloc>()),
        );
        break;

      case UserRole.staffCompany:
        providers.add(
          BlocProvider(create: (_) => sl<WorkorderBloc>()),
        );
        break;

      case UserRole.client:
        providers.add(
          BlocProvider(create: (_) => sl<CsrBloc>()),
        );
        break;

      default:
        break;
    }

    return providers;
  }
}
