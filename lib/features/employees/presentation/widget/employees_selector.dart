import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/shared/widgets/select_buttom_sheet.dart';

class EmployeesSelector extends StatelessWidget {
  const EmployeesSelector({
    super.key,
    required this.selectedEmployees,
    required this.availableEmployees,
    required this.onAdd,
    required this.buttonBuilder,
    this.isLoading = false,
  });

  final List<UserEntity> selectedEmployees;
  final List<UserEntity> availableEmployees;
  final void Function(UserEntity) onAdd;
  final bool isLoading;

  final Widget Function(
    BuildContext context,
    VoidCallback onPressed,
    bool isLoading,
  ) buttonBuilder;

  Future<void> _openEmployeeSelector(BuildContext context) async {
    if (isLoading) return;

    final employee = await showModalBottomSheet<UserEntity>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SelectBottomSheet<UserEntity>(
        title: 'Pilih Pegawai',
        items: availableEmployees,
        itemLabel: (e) => e.name, 
        isLoading: isLoading,
        tipe: WidgetTipe.user,
        onSelect: (selected) => Navigator.pop(context, selected),
      ),
    );

    if (employee != null &&
        !selectedEmployees.any((e) => e.email == employee.email)) {
      onAdd(employee);
    }
  }

  @override
  Widget build(BuildContext context) {
    return buttonBuilder(
      context,
      () => _openEmployeeSelector(context),
      isLoading,
    );
  }
}
