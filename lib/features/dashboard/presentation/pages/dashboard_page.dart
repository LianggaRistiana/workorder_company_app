import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/authorization/feature/service_request_permission.dart';
import 'package:workorder_company_app/core/authorization/feature/work_order_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/dashboard/presentation/widgets/service_request_donut_chart.dart';
import 'package:workorder_company_app/features/dashboard/presentation/widgets/work_order_donut_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServiceRequestDonutChart()
                      .require(roleCan(ServiceRequestPermission.view)),
                  WorkOrderDonutChart()
                      .require(roleCan(WorkOrderPermissions.view)),
                ],
              )),
        ),
      ),
    );
  }
}
