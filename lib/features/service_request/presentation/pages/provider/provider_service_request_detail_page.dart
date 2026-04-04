import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/authorization/util/permission_gate_on_widget.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/policies/provider_service_request_policy.dart';

class ProviderServiceRequestDetailPage extends StatelessWidget {
  final ProviderServiceRequestEntity request;

  const ProviderServiceRequestDetailPage({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Container()
        .require(ProviderServiceRequestPolicy(request: request).approvalRule);
  }
}
