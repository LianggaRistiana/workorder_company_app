import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_draft_entity.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_entity.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/actions/invitation_code_action_cubit.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/actions/invitation_code_action_state.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/positions_selector_container.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';


class InvitationCodeFormSheet extends StatefulWidget {
  final InvitationCodeEntity? existingCode;

  const InvitationCodeFormSheet({super.key, this.existingCode});

  @override
  State<InvitationCodeFormSheet> createState() =>
      _InvitationCodeFormSheetState();
}

class _InvitationCodeFormSheetState extends State<InvitationCodeFormSheet> {
  late UserRole _selectedRole;
  PositionEntity? _selectedPosition;
  final _customCodeController = TextEditingController();
  final _maxUsesController = TextEditingController();
  final _expiresInDaysController = TextEditingController();

  bool get isEditing => widget.existingCode != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingCode;
    _selectedRole = existing?.role ?? UserRole.staffCompany;
    _selectedPosition = existing?.position;
    if (existing?.maxUses != null) {
      _maxUsesController.text = existing!.maxUses!.toString();
    }
  }

  @override
  void dispose() {
    _customCodeController.dispose();
    _maxUsesController.dispose();
    _expiresInDaysController.dispose();
    super.dispose();
  }

  bool get _isOwner {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      return authState.user.role == UserRole.ownerCompany;
    }
    return false;
  }

  bool get _isDepartmentManager {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      return authState.user.role == UserRole.managerCompany &&
          authState.user.position != null;
    }
    return false;
  }

  PositionEntity? get _lockedPosition {
    if (!_isDepartmentManager) return null;
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) return authState.user.position;
    return null;
  }

  void _submit() {
    final posId = _selectedPosition?.id ?? _lockedPosition?.id;
    final maxUsesText = _maxUsesController.text.trim();
    final expiresText = _expiresInDaysController.text.trim();

    final draft = InvitationCodeDraftEntity(
      role: _selectedRole,
      positionId: posId,
      customCode: _customCodeController.text.trim().isEmpty
          ? null
          : _customCodeController.text.trim(),
      maxUses: maxUsesText.isEmpty ? null : int.tryParse(maxUsesText),
      expiresInDays: expiresText.isEmpty ? null : int.tryParse(expiresText),
    );

    if (isEditing) {
      context
          .read<InvitationCodeActionCubit>()
          .update(widget.existingCode!.id, draft);
    } else {
      context.read<InvitationCodeActionCubit>().create(draft);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lockedPos = _lockedPosition;

    return BlocBuilder<InvitationCodeActionCubit, InvitationCodeActionState>(
      builder: (context, actionState) {
        final isLoading =
            actionState.status == InvitationCodeActionStatus.loading;

        return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditing ? 'Edit Kode Undangan' : 'Buat Kode Undangan',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),

                  // Role picker — owner sees both, manager sees staff only
                  Text('Peran', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Pegawai'),
                        selected: _selectedRole == UserRole.staffCompany,
                        onSelected: (_) =>
                            setState(() => _selectedRole = UserRole.staffCompany),
                      ),
                      if (_isOwner)
                        ChoiceChip(
                          label: const Text('Manager'),
                          selected: _selectedRole == UserRole.managerCompany,
                          onSelected: (_) =>
                              setState(() => _selectedRole = UserRole.managerCompany),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Department picker
                  if (lockedPos != null) ...[
                    Text('Departemen',
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: lockedPos.name,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Departemen',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ] else if (_selectedRole == UserRole.staffCompany ||
                      _selectedRole == UserRole.managerCompany) ...[
                    Text('Departemen',
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    PositionsSelectorContainer(
                      selectedPositions: _selectedPosition != null ? [_selectedPosition!] : [],
                      onAdd: (p) => setState(() => _selectedPosition = p),
                      buttonBuilder: (context, onPressed, isLoadingSelector) {
                        if (_selectedPosition != null) {
                          return ClickableCustomCard(
                            margin: const EdgeInsets.all(0),
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
                                    _selectedPosition!.name,
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
                          isLoading: isLoadingSelector,
                        );
                      },
                    ),
                  ],


                  const SizedBox(height: 16),

                  // Optional custom code (create only)
                  if (!isEditing)
                    CustomInputField(
                      controller: _customCodeController,
                      label: 'Kode Kustom (opsional)',
                      hint: 'Biarkan kosong untuk auto-generate',
                      enabled: !isLoading,
                    ),

                  const SizedBox(height: 16),

                  // Max uses
                  CustomInputField(
                    controller: _maxUsesController,
                    label: 'Maks Penggunaan (opsional)',
                    hint: 'Kosong = tidak terbatas',
                    keyboardType: TextInputType.number,
                    enabled: !isLoading,
                  ),

                  const SizedBox(height: 16),

                  // Expires in days
                  if (!isEditing)
                    CustomInputField(
                      controller: _expiresInDaysController,
                      label: 'Kedaluwarsa (hari, opsional)',
                      hint: 'Kosong = tidak kedaluwarsa',
                      keyboardType: TextInputType.number,
                      enabled: !isLoading,
                    ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ButtonWithLoadingState(
                      icon: isEditing ? AppIcon.edit : AppIcon.add,
                      label: isEditing ? 'Simpan Perubahan' : 'Buat Kode',
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
  }
}
