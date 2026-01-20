import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/fetch_company/company_bloc.dart';

class PublicCompaniesWrapper extends StatelessWidget {
  final Widget child;
  const PublicCompaniesWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CompanyBloc>()),
        // TODO : add submission intake bloc here
      ],
      child: child,
    );
  }
}
