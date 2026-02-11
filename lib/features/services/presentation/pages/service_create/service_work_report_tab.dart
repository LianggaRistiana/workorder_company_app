import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/add_service_cubit.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/service_config_state.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/work_report_config_item.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class ServiceWorkReportTab extends StatelessWidget {
  const ServiceWorkReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: BlocBuilder<AddServiceCubit, ServiceConfigState>(
          builder: (context, state) {
            return CustomList(
              emptyWidget: InformationBlock.error(
                  "Tambahkan Perintah Kerja terlebih dahulu sebelum konfigurasi laporan"),
              items: state.serviceConfig.workOrderConfigs,
              itemBuilder: (item, index) => WorkReportConfigItem(
                  onApprovalChange: (value) {
                    context
                        .read<AddServiceCubit>()
                        .updateWorkReportApprovalAccess(value, index);
                  },
                  onFormUpdate: (form) {
                    context
                        .read<AddServiceCubit>()
                        .updateWorkReportForm(form, index);
                  },
                  draft: item),
            );
          },
        ));
  }
}
