import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/invitations/presentation/widgets/invitation_config_card.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_event.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';

class InviteEmployeePage extends StatelessWidget {
  const InviteEmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Tambahkan bloc di sini nanti
        BlocProvider(create: (_) => sl<PositionsListBloc>()..add(GetPositionsListRequested())),
      ],
      child: const _InviteEmployeeView(),
    );
  }
}

class _InviteEmployeeView extends StatefulWidget {
  const _InviteEmployeeView();

  @override
  State<_InviteEmployeeView> createState() => _InviteEmployeeViewState();
}

class _InviteEmployeeViewState extends State<_InviteEmployeeView> {
  final List<_InviteEntry> _invites = [];

  @override
  void initState() {
    super.initState();
    _addInvite();
  }

  void _addInvite() {
    setState(() {
      _invites.insert(0, _InviteEntry());
    });
  }

  void _removeInvite(int index) {
    setState(() {
      _invites.removeAt(index);
    });
  }

  void _submitInvites() {
    final payload = {
      "invites": _invites.map((e) => e.toRequestBody()).toList(),
    };

    debugPrint(payload.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Undangan Pegawai")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DashedButton(
              title: "Tambah Undangan",
              icon: Icons.add,
              onTap: _addInvite,
              height: 100,
              color: Theme.of(context).colorScheme.primary,
              borderColor: Theme.of(context).colorScheme.primary,
              // borderColor: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _invites.isEmpty
                  ? const Center(child: Text('Belum ada Undangan'))
                  : ListView.builder(
                      itemCount: _invites.length,
                      itemBuilder: (context, index) {
                        final invite = _invites[index];

                        return InvitationConfigCard(
                          email: invite.email ?? '',
                          role: invite.role ?? UserRole.staffCompany,
                          position: invite.position,
                          onEmailChanged: (val) {
                            invite.email = val;
                          },
                          onRoleChanged: (val) {
                            setState(() {
                              invite.role = val;
                              if (val != UserRole.staffCompany) {
                                invite.position = null;
                              }
                            });
                          },
                          onPositionChanged: (val) {
                            setState(() {
                              invite.position = val;
                            });
                          },
                          onRemove: () => _removeInvite(index),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _submitInvites,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor:
                    Theme.of(context).colorScheme.primary,
                textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              child: const Text('Kirim Undangan'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InviteEntry {
  String? email;
  UserRole? role;
  PositionEntity? position;

  Map<String, dynamic> toRequestBody() {
    return {
      "email": email,
      "role": role?.toSnakeCase(),
      "positionId": position?.id,
    };
  }
}
