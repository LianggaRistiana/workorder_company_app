import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                            icon: Icons.badge_outlined,
                            label: "Departemen bertugas",
                            value: config.positionOnDuty.name),
                        PropertyItem.text(
                            icon: Icons.people_alt_outlined,
                            label: "Pegawai Diperlukan",
                            value:
                                "${config.minStaff} hingga ${config.maxStaff} orang"),
                      ]),
                      const Divider(),
                      PropertyDisplay(showDivider: false, properties: [
                        PropertyItem.widget(
                          label: "Formulir Perintah Kerja",
                          icon: Icons.build_circle_outlined,
                          child: ClickableCustomCard(
                              onTap: () {
                                context.pop();
                                context.push(AppRoutes.formsDetail
                                    .fillId(config.workOrderForm.id));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    config.workOrderForm.title,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    config.workOrderForm.description,
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              )),
                        ),
                        PropertyItem.text(
                            icon: Icons.shield_outlined,
                            label: "Hak Persetujuan Perintah Kerja",
                            value:
                                config.workOrderAprrovalAccessType.displayName)
                      ]),
                      const Divider(),
                      PropertyDisplay(showDivider: false, properties: [
                        PropertyItem.widget(
                          label: "Formulir Laporan",
                          icon: Icons.build_circle_outlined,
                          child: ClickableCustomCard(
                              onTap: () {},
                              child: Text(config.workReportForm.title)),
                        ),
                        PropertyItem.text(
                            icon: Icons.shield_outlined,
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
            icon: Icons.build_circle_outlined,
            value: config.workOrderForm.title,
          ),
          PropertyItem.text(
            label: "Formulir Laporan",
            icon: Icons.build_circle_outlined,
            value: config.workReportForm.title,
          ),
          PropertyItem.text(
              icon: Icons.badge_outlined,
              label: "Departemen bertugas",
              value: config.positionOnDuty.name)
        ]));
  }
}
