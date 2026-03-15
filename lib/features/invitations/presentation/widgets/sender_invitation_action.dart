import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_entity.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/sender_actions/sender_invitation_actions_cubit.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/sender_actions/sender_invitation_actions_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

class SenderInvitationAction extends StatelessWidget {
  final InvitationEntity invitation;

  const SenderInvitationAction({
    super.key,
    required this.invitation,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SenderInvitationActionsCubit,
        SenderInvitationActionsState>(
      listener: (context, state) {
        if (state.status == SenderInvitationActionsStatus.success) {
          Navigator.of(context).pop();
          context.showSuccess("Undangan berhasil dibatalkan");
        }

        if (state.status == SenderInvitationActionsStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }
      },
      builder: (context, state) {
        final isLoading = state.status == SenderInvitationActionsStatus.loading;

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              child: const Text("Tutup"),
            ),
            if (invitation.status == InvitationStatus.pending) ...[
              const SizedBox(width: 16),
              FilledButton(
                onPressed: isLoading
                    ? null
                    : () {
                        context
                            .read<SenderInvitationActionsCubit>()
                            .cancelInvitation(invitation.id);
                      },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Batalkan Undangan"),
              ),
            ]
          ],
        );
      },
    );
  }
}
