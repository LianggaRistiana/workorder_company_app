import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/base_service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/service_request_status_icon.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/user_requester_chip.dart';

enum ServiceRequestType { requester, receiver }

class ServiceRequestItem extends StatelessWidget {
  final ServiceRequestType type;
  final BaseServiceRequestEntity serviceRequest;
  final VoidCallback? onTap;
  final CompanyEntity? toCompany;

  const ServiceRequestItem._({
    super.key,
    required this.type,
    required this.serviceRequest,
    this.onTap,
    this.toCompany,
  });

  const ServiceRequestItem.requester({
    Key? key,
    required BaseServiceRequestEntity serviceRequest,
    required VoidCallback? onTap,
    required CompanyEntity toCompany,
  }) : this._(
          key: key,
          type: ServiceRequestType.requester,
          serviceRequest: serviceRequest,
          onTap: onTap,
          toCompany: toCompany,
        );

  const ServiceRequestItem.receiver(
      {Key? key,
      required CompanyEntity toCompany,
      required BaseServiceRequestEntity serviceRequest,
      required VoidCallback? onTap})
      : this._(
          key: key,
          type: ServiceRequestType.receiver,
          serviceRequest: serviceRequest,
          onTap: onTap,
        );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.only(
          top: AppSpacing.sm,
          bottom: AppSpacing.sm,
          left: AppSpacing.md,
          right: AppSpacing.lg,
        ),
        child: Row(children: [
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
                    Text(serviceRequest.service.title,
                        style: Theme.of(context).textTheme.bodySmall),
                    if (type == ServiceRequestType.receiver) ...[
                      const Spacer(),
                      UserRequesterChip(name: serviceRequest.requestedBy.name)
                    ]
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    if (type == ServiceRequestType.requester) ...[
                      Text(toCompany!.name,
                          style: Theme.of(context).textTheme.labelSmall)
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
        ]),
      ),
    );
  }
}
