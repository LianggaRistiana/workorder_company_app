import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/authorization/util/permission_gate_on_widget.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/internal_service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/policies/internal_service_request_policy.dart';

class ReceiverServiceRequestDetailPage extends StatelessWidget {
  final InternalServiceRequestEntity request;

  const ReceiverServiceRequestDetailPage({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Container()
        .require(InternalServiceRequestPolicy(request: request).approvalRule);
  }
}
