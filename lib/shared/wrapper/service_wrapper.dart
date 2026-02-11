import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/forms_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/positions_bloc.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/add_service_cubit.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/services_bloc.dart';

class ServiceWrapper extends StatelessWidget {
  final Widget child;
  const ServiceWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ServicesBloc>()),
        BlocProvider(create: (_) => sl<PositionsBloc>()),
        BlocProvider(create: (_) => sl<FormsBloc>()),
        BlocProvider(create: (_) => sl<AddServiceCubit>()),
      ],
      child: child,
    );
  }
}
