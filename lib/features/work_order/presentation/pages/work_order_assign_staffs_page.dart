import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/domain/params/employees_params.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:workorder_company_app/features/employees/presentation/widget/employees_selector_container.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/fill/fill_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/fill/fill_work_order_state.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/presentation/widgets/staff_chip.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class WorkOrderAssignStaffsPage extends StatefulWidget {
  final WorkOrderEntity workOrder;
  const WorkOrderAssignStaffsPage({super.key, required this.workOrder});

  @override
  State<WorkOrderAssignStaffsPage> createState() =>
      _WorkOrderAssignStaffsPageState();
}

class _WorkOrderAssignStaffsPageState extends State<WorkOrderAssignStaffsPage> {
  UserEntity? staffPic;
  List<UserEntity> staffs = [];

  @override
  void initState() {
    super.initState();
  }

  void onAddStaffPic(UserEntity staff) {
    setState(() {
      staffPic = staff;
      staffs.add(staff);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<FillWorkOrderCubit>()),
          BlocProvider(
              create: (_) => sl<EmployeesBloc>()
                ..add(GetEmployeesRequested(
                    params: EmployeesParams(
                  positionId: widget.workOrder.positionOnDuty.id,
                )))),
        ],
        child: BlocConsumer<FillWorkOrderCubit, FillWorkOrderState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(),
              body: SafeArea(
                  child: AdaptiveSplitColumn(
                      leftChildren: _staffPicArea(), rightChildren: [])),
            );
          },
        ));
  }

  List<Widget> _staffPicArea() {
    return [
      PropertyTitle(label: "Penanggung Jawab"),
      EmployeesSelectorContainer(
          selectedEmployees: staffPic != null ? [staffPic!] : [],
          onAdd: onAddStaffPic,
          buttonBuilder: (context, onPressed, isLoading) => staffPic == null
              ? DashedButton(
                  icon: AppIcon.add,
                  onTap: onPressed,
                  isLoading: isLoading,
                  title: "Pilih Penanggung Jawab",
                )
              : ClickableCustomCard(
                  onTap: onPressed, 
                  child: StaffChip(user: staffPic!),
                ))
    ];
  }
}
