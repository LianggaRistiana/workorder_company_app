import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/shared/widgets/select_buttom_sheet.dart';

class EmployeeSelector extends StatelessWidget {
  final List<UserEntity> availableEmployees;
  final List<UserEntity> selectedEmployees;
  final void Function(UserEntity) onAdd;
  final bool isLoading;
  final String title;

  const EmployeeSelector(
      {super.key,
      required this.availableEmployees,
      required this.onAdd,
      required this.isLoading,
      required this.selectedEmployees,
      this.title = "pegawai"});

  Future<void> _openPositionSelector(
    BuildContext context,
    final List<UserEntity> availableEmployees,
    bool isLoading,
  ) async {
    if (isLoading) return;

    final employee = await showModalBottomSheet<UserEntity>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SelectBottomSheet<UserEntity>.user(
        title: 'Pilih $title',
        items: availableEmployees,
        itemLabel: (p) => p.name,
        isLoading: isLoading,
        onSelect: (selected) => Navigator.pop(context, selected),
      ),
    );

    if (employee != null && !selectedEmployees.any((p) => p == employee)) {
      onAdd(employee);
    }
  }

  Widget _buildButton(BuildContext context, List<UserEntity> availableEmployees,
      bool isLoading) {
    return TextButton.icon(
      icon: const Icon(Icons.add),
      label: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text('Tambah $title'),
      onPressed: isLoading
          ? null
          : () => _openPositionSelector(context, availableEmployees, isLoading),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildButton(context, availableEmployees, isLoading);
  }
}
