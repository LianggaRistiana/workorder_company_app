import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/service_form_entity.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';

class ServiceFormCard extends StatelessWidget {
  final ServiceFormEntity serviceForm;

  const ServiceFormCard({
    super.key,
    required this.serviceForm,
  });

  final selectableRoles = const [
    UserRole.managerCompany,
    UserRole.staffCompany,
    UserRole.client,
  ];

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      elevation: 1,
      padding: const EdgeInsets.all(0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.push(AppRoutes.ownerFormDetail(serviceForm.form.id));
        },
        child: Padding(
          padding: const EdgeInsets.all(12), // beri padding manual
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.assignment_turned_in_outlined,
                      size: 28,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    serviceForm.form.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Divider(),
              const SizedBox(height: 8),

              // Fillable Roles (Diisi oleh)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildRoleSection(
                      title: 'Diisi Oleh',
                      icon: Icons.edit,
                      context: context,
                      selectedRoles: serviceForm.fillableByRoles,
                      selectedPositions: serviceForm.fillableByPositions,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRoleSection(
                      title: 'Dilihat Oleh',
                      icon: Icons.visibility,
                      context: context,
                      selectedRoles: serviceForm.viewableByRoles,
                      selectedPositions: serviceForm.viewableByPositions,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<UserRole> selectedRoles,
    required List<PositionEntity> selectedPositions,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: selectedRoles.map((role) {
              return Chip(
                label: Text(role.displayName),
              );
            }).toList(),
          ),
          if (selectedRoles.contains(UserRole.staffCompany)) ...[
            const SizedBox(height: 8),
            CustomList(
              emptyWidget: const Text("Semua posisi staff terpilih"),
              separatorHeight: 8,
              items: selectedPositions,
              itemBuilder: (item, _) => _buildPositionItem(context, item),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPositionItem(BuildContext context, PositionEntity position) {
    return CustomCard(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 0,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.badge_outlined,
              size: 12,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 3,
            child: Text(
              position.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
