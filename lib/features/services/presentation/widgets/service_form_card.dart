import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/positions_selector.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_form_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/roles_selector.dart';

class ServiceFormCard extends StatelessWidget {
  final ServiceFormEntity serviceForm;
  final List<PositionEntity> availablePositions;
  final void Function(ServiceFormEntity) onUpdate;
  final void Function(ServiceFormEntity) onRemove;

  final selectableRoles = [
    UserRole.managerCompany,
    UserRole.staffCompany,
    UserRole.client,
  ];

  ServiceFormCard({
    super.key,
    required this.serviceForm,
    required this.availablePositions,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan remove button
          Row(
            children: [
              Expanded(
                child: Text(
                  serviceForm.form.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => onRemove(serviceForm),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(),

          // Fillable Roles
          RolesSelector(
            title: 'Diisi Oleh',
            roles: selectableRoles,
            selectedRoles: serviceForm.fillableByRoles,
            onChanged: (newRoles) {
              onUpdate(serviceForm.copyWith(
                fillableByRoles: newRoles,
                fillableByPositions: newRoles.contains(UserRole.staffCompany)
                    ? serviceForm.fillableByPositions
                    : [],
              ));
            },
          ),
          if (serviceForm.fillableByRoles.contains(UserRole.staffCompany))
            _buildPositionsSection(
              selectedPositions: serviceForm.fillableByPositions,
              onAdd: (pos) {
                onUpdate(serviceForm.copyWith(
                  fillableByPositions: [
                    ...serviceForm.fillableByPositions,
                    pos
                  ],
                ));
              },
              onRemove: (pos) {
                onUpdate(serviceForm.copyWith(
                  fillableByPositions: serviceForm.fillableByPositions
                      .where((p) => p.id != pos.id)
                      .toList(),
                ));
              },
            ),
          const SizedBox(height: 12),
          Divider(),

          // Viewable Roles
          RolesSelector(
            title: 'Dilihat Oleh',
            roles: selectableRoles,
            selectedRoles: serviceForm.viewableByRoles,
            onChanged: (newRoles) {
              onUpdate(serviceForm.copyWith(
                viewableByRoles: newRoles,
                viewableByPositions: newRoles.contains(UserRole.staffCompany)
                    ? serviceForm.viewableByPositions
                    : [],
              ));
            },
          ),
          const SizedBox(height: 12),
          if (serviceForm.viewableByRoles.contains(UserRole.staffCompany))
            _buildPositionsSection(
              selectedPositions: serviceForm.viewableByPositions,
              onAdd: (pos) {
                onUpdate(serviceForm.copyWith(
                  viewableByPositions: [
                    ...serviceForm.viewableByPositions,
                    pos
                  ],
                ));
              },
              onRemove: (pos) {
                onUpdate(serviceForm.copyWith(
                  viewableByPositions: serviceForm.viewableByPositions
                      .where((p) => p.id != pos.id)
                      .toList(),
                ));
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPositionsSection({
    required List<PositionEntity> selectedPositions,
    required void Function(PositionEntity) onAdd,
    required void Function(PositionEntity) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PositionsSelector(
          selectedPositions: selectedPositions,
          useBloc: false,
          positions: availablePositions,
          onAdd: onAdd,
        ),
        const SizedBox(height: 12),
        CustomList(
          emptyWidget: const Text("Semua posisi staff terpilih"),
          separatorHeight: 8,
          items: selectedPositions,
          itemBuilder: (item) => _buildPositionOptionItem(item, onRemove),
        ),
      ],
    );
  }

  Widget _buildPositionOptionItem(
      PositionEntity position, void Function(PositionEntity) onRemove) {
    return CustomCard(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                position.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => onRemove(position),
            ),
          ],
        ),
      ),
    );
  }
}
