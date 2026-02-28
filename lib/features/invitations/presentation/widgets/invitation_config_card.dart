import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/positions_selector_container.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/enum_selector.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class InvitationConfigCard extends StatelessWidget {
  final String email;
  final UserRole role;
  final PositionEntity? position;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<UserRole> onRoleChanged;
  final ValueChanged<PositionEntity?> onPositionChanged;
  final VoidCallback onRemove;

  const InvitationConfigCard(
      {super.key,
      required this.email,
      required this.role,
      this.position,
      required this.onEmailChanged,
      required this.onRoleChanged,
      required this.onPositionChanged,
      required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
                CustomInputField(label: "Email", onChanged: onEmailChanged),
        const SizedBox(height: 12),
        EnumSelector(
            isMultiSelect: false,
            title: "Pilih Role",
            values: [UserRole.staffCompany, UserRole.managerCompany],
            labelBuilder: (position) => position.displayName,
            selectedValues: [role],
            onChanged: (role) {
              if (role.isNotEmpty) {
                return onRoleChanged(role.first);
              } else {
                return;
              }
            }),
        const SizedBox(height: 12),
        if (role == UserRole.staffCompany)
          PositionsSelectorContainer(
            selectedPositions: position != null ? [position!] : [],
            onAdd: onPositionChanged,
            buttonBuilder: (context, onPressed, isLoading) {
              if (position != null) {
                return ClickableCustomCard(
                  margin: EdgeInsets.all(0),
                  onTap: onPressed,
                  child: Row(
                    children: [
                      const IconBox(
                        icon: Icons.badge_outlined,
                        paddingSize: 8,
                        iconSize: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          position!.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      )
                    ],
                  ),
                );
              }

              return DashedButton(
                title: "Pilih Departemen",
                onTap: onPressed,
                borderColor: Theme.of(context).disabledColor,
                color: Theme.of(context).colorScheme.primary,
                icon: Icons.add,
                height: 60,
                borderRadius: 12,
                isLoading: isLoading,
              );
            },
          ),
          const SizedBox(height: 12),
          IconButton.filled(
          onPressed: onRemove,
          icon: const Icon(Icons.delete_outline_rounded),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.error, // warna icon
          ),
        ),
      ],
    ));
  }
}
