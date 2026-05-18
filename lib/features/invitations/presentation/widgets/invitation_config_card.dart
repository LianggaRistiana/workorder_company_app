import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/invitations/domain/authorizer/sender_invite_authorizer.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/positions_selector_container.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/enum_selector.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/item_tile_lined.dart';

class InvitationConfigCard extends StatefulWidget {
  final String email;
  final UserRole role;
  final PositionEntity? position;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<UserRole> onRoleChanged;
  final ValueChanged<PositionEntity?> onPositionChanged;
  final VoidCallback? onRemove;

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
  State<InvitationConfigCard> createState() => _InvitationConfigCardState();
}

class _InvitationConfigCardState extends State<InvitationConfigCard> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomInputField(
            label: "Email",
            onChanged: widget.onEmailChanged,
            controller: _emailController),
        const SizedBox(height: 12),
        EnumSelector(
            isMultiSelect: false,
            title: "Pilih Role",
            values: [UserRole.staffCompany, UserRole.managerCompany],
            labelBuilder: (position) => position.displayName,
            selectedValues: [widget.role],
            onChanged: (role) {
              if (role.isNotEmpty) {
                return widget.onRoleChanged(role.first);
              } else {
                return;
              }
            }).require(
          SenderInviteAuthorizer().managerInvitationRule,
          fallback: ItemTileLined(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                "Sebagai ${widget.role.displayName}",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (widget.role == UserRole.managerCompany &&
            widget.position == null) ...[
          InformationBlock.info(
              "Undangan manager tanpa departemen akan menjadi manager general"),
          const SizedBox(height: 12),
        ] else if (widget.role == UserRole.managerCompany &&
            widget.position != null) ...[
          InformationBlock.info("akun ini diundang sebagai manager departemen"),
          const SizedBox(height: 12),
        ],
        PositionsSelectorContainer(
          selectedPositions: widget.position != null ? [widget.position!] : [],
          onAdd: widget.onPositionChanged,
          buttonBuilder: (context, onPressed, isLoading) {
            if (widget.position != null) {
              return ClickableCustomCard(
                margin: EdgeInsets.all(0),
                onTap: onPressed,
                child: Row(
                  children: [
                    const IconBox(
                      icon: AppIcon.department,
                      paddingSize: 8,
                      iconSize: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.position!.name,
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
        ).require(SenderInviteAuthorizer().configPositionRule,
            fallback: widget.position != null
                ? CustomCard(
                    margin: EdgeInsets.all(0),
                    child: Row(
                      children: [
                        const IconBox(
                          icon: AppIcon.department,
                          paddingSize: 8,
                          iconSize: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.position!.name,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        )
                      ],
                    ),
                  )
                : null),
        const SizedBox(height: 12),
        IconButton.filled(
          onPressed: widget.onRemove,
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
