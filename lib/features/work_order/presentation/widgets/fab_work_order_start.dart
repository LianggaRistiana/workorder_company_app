import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/work_order/domain/authorization/work_order_authorizer.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/start/start_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/start/start_work_order_state.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

class FabWorkOrderStart extends StatelessWidget {
  final WorkOrderEntity workOrder;

  const FabWorkOrderStart({super.key, required this.workOrder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartWorkOrderCubit, StartWorkOrderState>(
        builder: (context, state) {
      return FloatingActionButton.extended(
        icon: Icon(AppIcon.start),
        onPressed: () {},
        label: Text('Mulai'),
      ).withInlineLoading(state.status == StartWorkOrderStatus.loading);
    }).require(
      WorkOrderAuthorizer(workOrder: workOrder).startWorkOrder,
    );
  }
}
