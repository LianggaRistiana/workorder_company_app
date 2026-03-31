import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/client_service_request_legacy/presentation/bloc/internal_client_service_request/internal_csr_actions_cubit.dart';
import 'package:workorder_company_app/features/client_service_request_legacy/presentation/bloc/internal_client_service_request/internal_csr_bloc.dart';
import 'package:workorder_company_app/features/client_service_request_legacy/presentation/bloc/internal_client_service_request/internal_csr_detail_cubit.dart';

class CsrWrapper extends StatelessWidget {
  final Widget child;
  const CsrWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<InternalCsrBloc>()),
        BlocProvider(create: (_) => sl<InternalCsrDetailCubit>()),
        BlocProvider(create: (_) => sl<InternalCsrActionsCubit>()),
      ],
      child: child,
    );
  }
}