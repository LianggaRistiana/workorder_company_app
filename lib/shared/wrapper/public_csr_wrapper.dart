import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/public_client_service_request/csr_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/public_client_service_request/csr_detail_cubit.dart';

class PublicCsrWrapper extends StatelessWidget {
  final Widget child;
  const PublicCsrWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CsrBloc>()),
        BlocProvider(create: (_) => sl<CsrDetailCubit>()),
        // TODO : add submission intake bloc here
      ],
      child: child,
    );
  }
}
