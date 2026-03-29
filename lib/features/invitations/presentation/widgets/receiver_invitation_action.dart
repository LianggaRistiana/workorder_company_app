import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_entity.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/receiver_actions/receiver_invitation_actions_cubit.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/receiver_actions/receiver_invitation_actions_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

class ReceiverInvitationAction extends StatelessWidget {
  final InvitationEntity invitation;

  const ReceiverInvitationAction({super.key, required this.invitation});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReceiverInvitationActionsCubit,
        ReceiverInvitationActionsState>(
      listener: (context, state) {
        if (state.status == ReceiverInvitationActionsStatus.success) {
          if (state.action == ActionType.accept) {
            context.showSuccess("Undangan berhasil diterima");
            context.read<AuthBloc>().add(GetCurrentUserRequested());
            context.go(AppRoutes.home);
          }

          if (state.action == ActionType.reject) {
            context.showSuccess("Undangan berhasil ditolak");
            context.pop();
          }
        }

        if (state.status == ReceiverInvitationActionsStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }
      },
      builder: (context, state) {
        final isLoading =
            state.status == ReceiverInvitationActionsStatus.loading;
        return SizedBox(
          width: double.infinity,
          child: isLoading
              ? LoadingStateInline()
              : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
        );
      },
    );
  }
}
