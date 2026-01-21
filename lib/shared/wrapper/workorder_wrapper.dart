import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_submissions_forms_cubit.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_actions_cubit.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_assigned_staff_cubit.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_bloc.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_detail_cubit.dart';

class WorkorderWrapper extends StatelessWidget {
  final Widget child;
  const WorkorderWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<WorkorderBloc>()),
        BlocProvider(create: (_) => sl<WorkorderDetailCubit>()),
        BlocProvider(create: (_) => sl<EmployeesBloc>()),
        BlocProvider(create: (_) => sl<WorkorderActionsCubit>()),
        BlocProvider(create: (_) => sl<WorkorderSubmissionsFormsCubit>()),
        BlocProvider(create: (_) => sl<WorkorderAssignedStaffCubit>()),
      ],
      child: child,
    );
  }
}
