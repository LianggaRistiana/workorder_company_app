import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';

class ServiceRequestContent extends StatelessWidget {
  final bool isLoading;
  final ServiceRequestEntity? serviceRequest;

  const ServiceRequestContent({
    super.key,
    required this.isLoading,
    this.serviceRequest,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: AppLoading());
    }

    if (serviceRequest == null) {
      return const Center(child: EmptyStateWidget(text: 'Tidak ditemukan'));
    }

    if (serviceRequest is RequesterServiceRequestEntity) {
      return _buildRequesterContent(
          serviceRequest as RequesterServiceRequestEntity);
    } else if (serviceRequest is ProviderServiceRequestEntity) {
      return _buildProviderContent(
          serviceRequest as ProviderServiceRequestEntity);
    }

    return const SizedBox.shrink();
  }

  Widget _buildRequesterContent(RequesterServiceRequestEntity requester) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Requester Service Request',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('Service Code: ${requester.code}'),
        Text('Company: ${requester.company.name}'),
        Text('Status: ${requester.status.name}'),
        // Add more fields as needed
      ],
    );
  }

  Widget _buildProviderContent(ProviderServiceRequestEntity provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Provider Service Request',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('Service Code: ${provider.code}'),
        Text('Status: ${provider.status.name}'),
        Text('Review Needed: ${provider.reviewNeed}'),
        Text('Approval Access: ${provider.approvalAccess.name}'),
        // Add more fields as needed
      ],
    );
  }
}
