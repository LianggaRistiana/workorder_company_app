import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/work_order_config_entity.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/info_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class ServiceWorkOrderItemView extends StatelessWidget {
  final WorkOrderConfigEntity config;
  const ServiceWorkOrderItemView({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return ClickableCustomCard(
        onTap: () {
          showAppBottomSheet(context,
              // header: IconBox(icon: Icons.task_outlined),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () => context.pop(),
                    child: const Text("Tutup"),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PropertyDisplay(showDivider: false, properties: [
                        PropertyItem.text(
                            icon: AppIcon.department,
                            label: "Departemen bertugas",
                            value: config.positionOnDuty.name),
                        PropertyItem.text(
                            icon: AppIcon.employee,
                            label: "Pegawai Diperlukan",
                            value:
                                "${config.minStaff} hingga ${config.maxStaff} orang"),
                      ]),
                      const Divider(),
                      PropertyDisplay(showDivider: false, properties: [
                        PropertyItem.widget(
                            label: "Formulir Perintah Kerja",
                            icon: AppIcon.workOrder,
                            child:
                                ClickableFormCard(form: config.workOrderForm)),
                        PropertyItem.text(
                            icon: Icons.admin_panel_settings,
                            label: "Hak Persetujuan Perintah Kerja",
                            value:
                                config.workOrderAprrovalAccessType.displayName)
                      ]),
                      const Divider(),
                      PropertyDisplay(showDivider: false, properties: [
                        PropertyItem.widget(
                          label: "Formulir Laporan",
                          icon: AppIcon.workReport,
                          child: ClickableFormCard(form: config.workReportForm),
                        ),
                        PropertyItem.text(
                            icon: Icons.admin_panel_settings,
                            label: "Hak Persetujuan Laporan Kerja",
                            value:
                                config.workReportApprovalAccessType.displayName)
                      ])
                    ]),
              ));
        },
        child: PropertyDisplay(properties: [
          PropertyItem.text(
            label: "Formulir Perintah Kerja",
            icon: AppIcon.workOrder,
            value: config.workOrderForm.title,
          ),
          PropertyItem.text(
            label: "Formulir Laporan",
            icon: AppIcon.workReport,
            value: config.workReportForm.title,
          ),
          PropertyItem.text(
              icon: AppIcon.department,
              label: "Departemen bertugas",
              value: config.positionOnDuty.name)
        ]));
  }
}

class ClickableFormCard extends StatelessWidget {
  final FormEntity form;
  const ClickableFormCard({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ClickableCustomCard(
            onTap: () {
              context.pop();
              context.push(AppRoutes.formsDetail.fillId(form.id));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  form.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  form.description,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            )));
  }
}
