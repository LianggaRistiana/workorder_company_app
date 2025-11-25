import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/client_service_request/domain/entitties/client_service_request_entity.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/widgets/client_name_chip.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/widgets/csr_status_chip.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/widgets/csr_status_icon.dart';

class CsrItem extends StatelessWidget {
  final ClientServiceRequestEntity csr;
  final VoidCallback? onTap;
  const CsrItem({super.key, required this.csr, this.onTap});

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CsrStatusIcon(
              status: csr.status,
              width: 60,
              height: 70,
            ),

            const SizedBox(width: AppSpacing.md),

            // RIGHT SIDE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --------------------
                  // TITLE
                  // --------------------
                  Text(
                    csr.service.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // --------------------
                  // ROW: PERSON CHIP (left) + STATUS CHIP (right)
                  // --------------------
                  Row(
                    children: [
                      CsrStatusChip(
                        status: csr.status,
                        showIcon: false,
                      ),
                      const Spacer(),
                      ClientNameChip(name: csr.client.name),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // --------------------
                  // DATE (align right)
                  // --------------------
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        DateFormat('d MMM yyyy', 'id_ID').format(csr.createdAt),
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
