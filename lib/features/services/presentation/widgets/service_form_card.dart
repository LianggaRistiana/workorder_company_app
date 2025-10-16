import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_form_entity.dart';
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
            Text(
              serviceForm.form.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),
            const Divider(),

            // Fillable Roles (Diisi oleh)
            _buildRoleSection(
              title: 'Diisi Oleh',
              selectedRoles: serviceForm.fillableByRoles,
              selectedPositions: serviceForm.fillableByPositions,
            ),

            const SizedBox(height: 12),
            const Divider(),

            // Viewable Roles (Dilihat oleh)
            _buildRoleSection(
              title: 'Dilihat Oleh',
              selectedRoles: serviceForm.viewableByRoles,
              selectedPositions: serviceForm.viewableByPositions,
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildRoleSection({
    required String title,
    required List<UserRole> selectedRoles,
    required List<PositionEntity> selectedPositions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          children: selectedRoles.map((role) {
            return Chip(
              label: Text(_roleLabel(role)),
            );
          }).toList(),
        ),
        if (selectedRoles.contains(UserRole.staffCompany)) ...[
          const SizedBox(height: 8),
          CustomList(
            emptyWidget: const Text("Semua posisi staff terpilih"),
            separatorHeight: 8,
            items: selectedPositions,
            itemBuilder: (item, _) => _buildPositionItem(item),
          ),
        ],
      ],
    );
  }

  Widget _buildPositionItem(PositionEntity position) {
    return CustomCard(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      elevation: 0,
      child: Row(
        children: [
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

  String _roleLabel(UserRole role) {
    switch (role) {
      case UserRole.managerCompany:
        return 'Manager';
      case UserRole.staffCompany:
        return 'Staff';
      case UserRole.client:
        return 'Client';
      default:
        return role.toString();
    }
  }
}


