import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/service_request_status_icon.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/user_requester_chip.dart';

class ServiceRequestItem extends StatelessWidget {
  final ServiceRequestEntity serviceRequest;
  final VoidCallback? onTap;

  const ServiceRequestItem({
    super.key,
    required this.serviceRequest,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRequester = serviceRequest is RequesterServiceRequestEntity;
    final isProvider = serviceRequest is ProviderServiceRequestEntity;

    // Safely get toCompany for requester
    final CompanyEntity? toCompany = isRequester
        ? (serviceRequest as RequesterServiceRequestEntity).company
        : null;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(
          top: AppSpacing.sm,
          bottom: AppSpacing.sm,
          left: AppSpacing.md,
          right: AppSpacing.lg,
        ),
        child: Row(
          children: [
            ServiceRequestStatusIcon(status: serviceRequest.status),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceRequest.code,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Text(
                        serviceRequest.service.title,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (isProvider) ...[
                        const Spacer(),
                        UserRequesterChip(
                          name: serviceRequest.requestedBy.name,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      if (isRequester) ...[
                        Text(
                          toCompany!.name,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                      const Spacer(),
                      Text(
                        DateFormat('d MMM yyyy', 'id_ID')
                            .format(serviceRequest.createdAt),
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}