import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/list/forms_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_bloc.dart';
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
        BlocProvider(create: (_) => sl<PositionsListBloc>()),
        BlocProvider(create: (_) => sl<FormsListBloc>()),
        BlocProvider(create: (_) => sl<AddServiceCubit>()),
      ],
      child: child,
    );
  }
}
