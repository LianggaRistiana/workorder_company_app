import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_entity.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/actions/invitation_code_action_cubit.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/bloc/actions/invitation_code_action_state.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/widgets/invitation_code_form_sheet.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_bloc.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';


class InvitationCodeDetailSheet extends StatelessWidget {
  final InvitationCodeEntity code;

  const InvitationCodeDetailSheet({super.key, required this.code});

  Future<void> _copyCode(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: code.code));
    if (!context.mounted) return;
    context.showSuccess('Kode berhasil disalin: ${code.code}');
  }

  void _showEditForm(BuildContext context) {
    final actionCubit = context.read<InvitationCodeActionCubit>();
    final positionsBloc = context.read<PositionsListBloc>();
    context.pop();
    showAppBottomSheet(
      context,
      content: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: actionCubit),
          BlocProvider.value(value: positionsBloc),
        ],
        child: InvitationCodeFormSheet(existingCode: code),
      ),
    );
  }

  void _revoke(BuildContext context) {
    context.read<InvitationCodeActionCubit>().revoke(code.id);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<InvitationCodeActionCubit, InvitationCodeActionState>(
      listener: (context, state) {
        // Parent page handles actual navigation pop and snackbar
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Code display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    code.code,
                    style: textTheme.headlineSmall?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonalIcon(
                    onPressed: () => _copyCode(context),
                    icon: const Icon(Icons.copy_outlined, size: 16),
                    label: const Text('Salin Kode'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Details
            PropertyDisplay(
              properties: [
                PropertyItem.text(label: 'Peran', value: code.roleDisplayName),
                if (code.position != null)
                  PropertyItem.text(
                      label: 'Departemen', value: code.position!.name),
                PropertyItem.text(
                    label: 'Penggunaan', value: code.usageDisplay),
                PropertyItem.text(
                    label: 'Kedaluwarsa', value: code.localizeExpiresAt()),
                PropertyItem.text(
                    label: 'Dibuat pada', value: code.localizeCreatedAt()),
                if (code.createdBy != null)
                  PropertyItem.text(
                      label: 'Dibuat oleh', value: code.createdBy!.name),
              ],
            ),

            const SizedBox(height: 16),

            // Actions
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _showEditForm(context),
                icon: const Icon(AppIcon.edit),
                label: const Text('Edit Kode'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: BlocBuilder<InvitationCodeActionCubit,
                  InvitationCodeActionState>(
                builder: (context, state) {
                  final isLoading =
                      state.status == InvitationCodeActionStatus.loading;
                  return OutlinedButton.icon(
                    onPressed: isLoading ? null : () => _revoke(context),
                    icon: Icon(
                      AppIcon.delete,
                      color: isLoading ? null : colorScheme.error,
                    ),
                    label: Text(
                      isLoading ? 'Memproses...' : 'Cabut Kode',
                      style: TextStyle(
                          color: isLoading ? null : colorScheme.error),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: isLoading
                              ? colorScheme.outline
                              : colorScheme.error),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
