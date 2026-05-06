import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/donut_data_entity.dart';
import 'package:workorder_company_app/features/dashboard/presentation/widgets/multi_donut_chart.dart';
import 'package:workorder_company_app/features/dashboard/presentation/widgets/toggleable_legend.dart';
import 'package:workorder_company_app/features/service_request/presentation/ui_mappers.dart/service_request_status_color_mapper.dart';
import 'package:workorder_company_app/features/work_order/presentation/ui_mappers/work_order_status_color_mapper.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class LabPage extends StatelessWidget {
  const LabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab Page"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomCard(
                  child: Column(
                children: [
                  PropertyTitle(
                    icon: AppIcon.workOrder,
                    label: "Perintah Kerja",
                  ),
                  MultiDonutChart(
                    data: [
                      ...WorkOrderStatus.values.map(
                        (e) {
                          return DonutDataEntity(
                              label: e.displayName, value: 40, color: e.color);
                        },
                      )
                    ],
                  ),
                  ToggleableLegend(data: [
                    ...WorkOrderStatus.values.map(
                      (e) {
                        return DonutDataEntity(
                            label: e.displayName, value: 40, color: e.color);
                      },
                    )
                  ])
                ],
              )),
              CustomCard(
                  child: Column(
                children: [
                  PropertyTitle(
                    icon: AppIcon.serviceRequestInbox,
                    label: "Permintaan Layanan",
                  ),
                  MultiDonutChart(
                    data: [
                      ...ServiceRequestStatus.values.map(
                        (e) {
                          return DonutDataEntity(
                              label: e.displayName, value: 20, color: e.color);
                        },
                      )
                    ],
                  ),
                  ToggleableLegend(data: [
                    ...ServiceRequestStatus.values.map(
                      (e) {
                        return DonutDataEntity(
                            label: e.displayName, value: 40, color: e.color);
                      },
                    )
                  ])
                ],
              )),
              CustomCard(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PropertyTitle(
                    icon: AppIcon.employee,
                    label: "Total Pegawai",
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "200",
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: const Text(
                      "Pegawai",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                        iconAlignment: IconAlignment.end,
                        icon: Icon(AppIcon.next),
                        onPressed: () {},
                        label: Text("Lihat Semua")),
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
