import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_entity.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/receiver_actions/receiver_invitation_actions_cubit.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/receiver_actions/receiver_invitation_actions_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

class ReceiverInvitationAction extends StatelessWidget {
  final InvitationEntity invitation;

  const ReceiverInvitationAction({super.key, required this.invitation});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReceiverInvitationActionsCubit,
        ReceiverInvitationActionsState>(
      listener: (context, state) {
        if (state.status == ReceiverInvitationActionsStatus.success) {
          // TODO : If accepted success get new CurrentUser data and direct to home page

          context.showSuccess("Undangan berhasil diterima");
          context.pop();
        }

        if (state.status == ReceiverInvitationActionsStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }
      },
      builder: (context, state) => SizedBox(
        width: double.infinity,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton(
              child: Text("Tolak"),
              onPressed: () => context
                  .read<ReceiverInvitationActionsCubit>()
                  .rejectInvitation(invitation.id)),
          const SizedBox(
            width: 16,
          ),
          TextButton(
              child: Text("Terima"),
              onPressed: () => context
                  .read<ReceiverInvitationActionsCubit>()
                  .acceptInvitation(invitation.id))
        ]),
      ),
    );
  }
}
