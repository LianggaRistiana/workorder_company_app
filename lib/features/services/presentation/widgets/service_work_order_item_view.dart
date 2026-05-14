import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/work_order_config_entity.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class ServiceWorkOrderItemView extends StatelessWidget {
  final WorkOrderConfigEntity config;
  final FormShowType formShowType;

  const ServiceWorkOrderItemView(
      {super.key, required this.config, required this.formShowType});

  @override
  Widget build(BuildContext context) {
    final workOrderForm = config.workOrderForm;

    return ClickableCustomCard(
        onTap: () {
          showAppBottomSheet(context,
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
                        if (workOrderForm != null)
                          PropertyItem.widget(
                              label: "Formulir Perintah Kerja",
                              icon: AppIcon.workOrder,
                              child: ClickableFormCard(
                                  formShowType: formShowType,
                                  form: workOrderForm)),
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
                          child: ClickableFormCard(
                              formShowType: formShowType,
                              form: config.workReportForm),
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
          if (workOrderForm != null)
            PropertyItem.text(
              label: "Formulir Perintah Kerja",
              icon: AppIcon.workOrder,
              value: workOrderForm.title,
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
  final FormShowType formShowType;

  const ClickableFormCard({
    super.key,
    required this.form,
    required this.formShowType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ClickableCustomCard(
            onTap: () {
              context.pop();
              if (formShowType == FormShowType.formDetailPage) {
                context.push(AppRoutes.formsDetail.fillId(form.id));
              } else if (formShowType == FormShowType.previewPage) {
                context.push(AppRoutes.templateFormPreview, extra: form);
              }
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
