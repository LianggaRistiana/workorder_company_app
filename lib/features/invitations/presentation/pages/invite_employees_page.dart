import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_draft_entity.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/invite/invite_employees_cubit.dart';
import 'package:workorder_company_app/features/invitations/presentation/bloc/invite/invite_employees_state.dart';
import 'package:workorder_company_app/features/invitations/presentation/widgets/invitation_config_card.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_event.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';

class InviteEmployeePage extends StatelessWidget {
  const InviteEmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<PositionsListBloc>()..add(GetPositionsListRequested()),
        ),
        BlocProvider(
          create: (_) => sl<InviteEmployeesCubit>(),
        ),
      ],
      child: BlocConsumer<InviteEmployeesCubit, InviteEmployeesState>(
        listener: (context, state) {
          if (state.status == InviteEmployeesStatus.error) {
            context.showError(state.errorMessage ?? 'Terjadi kesalahan');
          }

          if (state.status == InviteEmployeesStatus.success) {
            context.showSuccess('Undangan berhasil dikirim');
            context.pop();
          }
        },
        builder: (context, state) {
          return _InviteEmployeeView(state: state);
        },
      ),
    );
  }
}

class _InviteEmployeeView extends StatefulWidget {
  final InviteEmployeesState state;

  const _InviteEmployeeView({required this.state});

  @override
  State<_InviteEmployeeView> createState() => _InviteEmployeeViewState();
}

class _InviteEmployeeViewState extends State<_InviteEmployeeView> {
  final List<InvitationDraftEntity> _invites = [];

  @override
  void initState() {
    super.initState();
    _addInvite();
  }

  void _addInvite() {
    setState(() {
      _invites.insert(
        0,
        InvitationDraftEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          email: '',
          role: UserRole.staffCompany,
          position: null,
        ),
      );
    });
  }

  void _removeInvite(int index) {
    setState(() {
      _invites.removeAt(index);
    });
  }

  void _updateInvite(int index, InvitationDraftEntity updated) {
    setState(() {
      _invites[index] = updated;
    });
  }

  void _submitInvites() {
    final cubit = context.read<InviteEmployeesCubit>();

    final validInvites = _invites.where((e) => e.email.isNotEmpty).toList();

    if (validInvites.isEmpty) return;

    cubit.inviteEmployees(validInvites);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.state.status == InviteEmployeesStatus.loading;

    return Scaffold(
      appBar: AppBar(title: const Text("Undangan Pegawai")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DashedButton(
              title: "Tambah Undangan",
              icon: Icons.add,
              onTap: isLoading ? null : _addInvite,
              height: 100,
              color: Theme.of(context).colorScheme.primary,
              borderColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _invites.isEmpty
                  ? const Center(
                      child: Text('Belum ada Undangan'),
                    )
                  : ListView.builder(
                      itemCount: _invites.length,
                      itemBuilder: (context, index) {
                        final invite = _invites[index];

                        return InvitationConfigCard(
                          key: ValueKey(invite.id),
                          email: invite.email,
                          role: invite.role,
                          position: invite.position,
                          onEmailChanged: (val) {
                            _updateInvite(
                              index,
                              invite.copyWith(email: val),
                            );
                          },
                          onRoleChanged: (val) {
                            _updateInvite(
                              index,
                              invite.copyWith(
                                role: val,
                                position: val != UserRole.staffCompany
                                    ? null
                                    : invite.position,
                              ),
                            );
                          },
                          onPositionChanged: (val) {
                            _updateInvite(
                              index,
                              invite.copyWith(position: val),
                            );
                          },
                          onRemove:
                              isLoading ? null : () => _removeInvite(index),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            ButtonWithLoadingState(
                icon: AppIcon.send,
                onPressed: _submitInvites,
                isLoading: isLoading,
                label: "Kirim Undangan"),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
