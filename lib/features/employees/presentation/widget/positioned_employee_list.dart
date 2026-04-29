import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/employees/domain/params/employees_params.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:workorder_company_app/features/employees/presentation/widget/employee_item.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

class PositionedEmployeeList extends StatelessWidget {
  final PositionEntity position;
  const PositionedEmployeeList({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EmployeesBloc>()
        ..add(GetEmployeesRequested(
          params: EmployeesParams(positionId: position.id),
        )),
      child: BlocConsumer<EmployeesBloc, EmployeesState>(
          listener: (context, state) {
        if (state.errorMessage != null) {
          context.showError(
              state.errorMessage ?? " Terjadi Kesalahan saat memuat pegawai");
        }
      }, builder: (context, state) {
        if (state.isLoading) {
          return const LoadingStateInline(
            isEndAlign: false,
          );
        }
        return CustomList(
            items: state.employees,
            emptyWidget: InformationBlock.empty("Belum ada pegawai"),
            itemBuilder: (item, index) => EmployeeItem(
                  user: item,
                  margin: const EdgeInsets.all(0),
                ));
      }),
    );
  }
}
