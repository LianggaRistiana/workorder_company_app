import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/work_order_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_enum.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/create/work_order_create_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/create/work_order_create_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

class FabWorkOrderCreate extends StatelessWidget {
  const FabWorkOrderCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkOrderCreateCubit, WorkOrderCreateState>(
        listener: (context, state) {
      if (state.status == WorkOrderCreateStatus.error) {
        context.showError(state.errorMessage ??
            "Terjadi kesalahan saat membuat perintah kerja");
      }
      if (state.status == WorkOrderCreateStatus.success &&
          state.workOrder != null) {
        context.showSuccess("Perintah kerja berhasil dibuat");
        context.push(AppRoutes.workOrdersDetail.fillId(state.workOrder!.id));
      }
    }, builder: (context, state) {
      return FloatingActionButton.extended(
        heroTag: null,
        icon: Icon(AppIcon.workOrder),
        onPressed: () async {
          final result = await context.push<ServiceSummaryEntity?>(
              AppRoutes.services,
              extra: ServiceListNextAction.createWorkOrder);

          if (!context.mounted) return;
          if (result == null) return;

          context.read<WorkOrderCreateCubit>().createWorkOrder(result.id);
        },
        label: Text('Buat Perintah Kerja'),
      ).withInlineLoading(
        state.status == WorkOrderCreateStatus.loading,
      );
    }).require(roleCan(WorkOrderPermissions.create));
  }
}
