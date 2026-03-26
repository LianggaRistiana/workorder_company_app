import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/create/service_create_cubit.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/create/service_create_state.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/work_report_config_item.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class ServiceWorkReportFormTabView extends StatelessWidget {
  const ServiceWorkReportFormTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: BlocBuilder<ServiceCreateCubit, ServiceCreateState>(
          builder: (context, state) {
            return CustomList(
              emptyWidget: InformationBlock.error(
                  "Tambahkan Perintah Kerja terlebih dahulu sebelum konfigurasi laporan"),
              items: state.serviceConfig.workOrderConfigs,
              itemBuilder: (item, index) => WorkReportConfigItem(
                  onApprovalChange: (value) {
                    context
                        .read<ServiceCreateCubit>()
                        .updateWorkReportApprovalAccess(value, index);
                  },
                  onFormUpdate: (form) {
                    context
                        .read<ServiceCreateCubit>()
                        .updateWorkReportForm(form, index);
                  },
                  draft: item),
            );
          },
        ));
  }
}
