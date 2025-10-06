import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class InviteEmployeePage extends StatefulWidget {
  const InviteEmployeePage({super.key});

  @override
  State<InviteEmployeePage> createState() => _InviteEmployeePageState();
}

class _InviteEmployeePageState extends State<InviteEmployeePage> {
  final List<_InviteEntry> _invites = [];
  final List<PositionEntity> _positionOptions = const [
    PositionEntity(id: '1', name: 'Manager'),
    PositionEntity(id: '2', name: 'Supervisor'),
    PositionEntity(id: '3', name: 'Staff'),
    PositionEntity(id: '4', name: 'Technician'),
  ];

  @override
  void initState() {
    super.initState();
    _addInvite();
  }

  void _addInvite() {
    setState(() {
      _invites.insert(0, _InviteEntry()); // baru selalu ditambahkan ke atas
    });
  }

  void _removeInvite(int index) {
    setState(() {
      _invites.removeAt(index);
    });
  }

  void _submitInvites() {
    // ✅ Tambahkan aksi bloc submit di sini
    // final payload = {
    //   "invites": _invites.map((e) => e.toRequestBody()).toList(),
    // };
    // print(payload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invite Employee")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            OutlinedButton.icon(
              onPressed: _addInvite,
              icon: const Icon(Icons.add),
              label: const Text(
                'Tambah Invite',
                style: TextStyle(fontSize: 16),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _invites.isEmpty
                  ? const Center(child: Text('Belum ada invite'))
                  : ListView.builder(
                      itemCount: _invites.length,
                      itemBuilder: (context, index) {
                        final invite = _invites[index];
                        return _buildInviteCard(invite, index);
                      },
                    ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _submitInvites,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              child: const Text('Kirim Invite'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteCard(_InviteEntry invite, int index) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    );
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'example@company.com',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (val) => invite.email = val,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<UserRole>(
              value: invite.role,
              decoration: InputDecoration(
                labelText: 'Role',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: inputBorder,
                focusedBorder: inputBorder.copyWith(
                  borderSide: BorderSide(width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
              items: const [
                DropdownMenuItem(
                  value: UserRole.managerCompany,
                  child: Text('Manager'),
                ),
                DropdownMenuItem(
                  value: UserRole.staffCompany,
                  child: Text('Staff'),
                ),
              ],
              onChanged: (val) {
                setState(() {
                  invite.role = val;
                  if (val == UserRole.managerCompany) invite.positionId = null;
                });
              },
            ),
            if (invite.role == UserRole.staffCompany) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: invite.positionId,
                decoration: InputDecoration(
                  labelText: 'Pilih Posisi',
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorder.copyWith(
                    borderSide: BorderSide(width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                items: _positionOptions
                    .map((pos) =>
                        DropdownMenuItem(value: pos.id, child: Text(pos.name)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    invite.positionId = val;
                  });
                },
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _removeInvite(index),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text(
                  'Hapus',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wrapper untuk menyimpan data setiap entry invite
class _InviteEntry {
  String? email;
  UserRole? role;
  String? positionId;

  Map<String, dynamic> toRequestBody() {
    return {
      "email": email,
      "role": role?.toSnakeCase(),
      "positionId": positionId,
    };
  }
}
