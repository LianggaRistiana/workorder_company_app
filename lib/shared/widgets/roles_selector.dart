import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class RolesSelector extends StatelessWidget {
  final String title;
  final List<UserRole> roles;
  final List<UserRole> selectedRoles;
  final void Function(List<UserRole>) onChanged;

  const RolesSelector({
    super.key,
    required this.title,
    required this.roles,
    required this.selectedRoles,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Row(
          children: roles.map((role) {
            final isSelected = selectedRoles.contains(role);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SizedBox(
                  width: double.infinity,
                  child: FilterChip(
                    label: Center(child: Text(role.displayName)),
                    selected: isSelected,
                    onSelected: (selected) {
                      final updatedRoles = selected
                          ? [...selectedRoles, role]
                          : selectedRoles.where((r) => r != role).toList();
                      onChanged(updatedRoles);
                    },
                  ),
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
