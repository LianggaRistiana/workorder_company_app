import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_form_entity.dart';
import '../../domain/entities/form_entity.dart';
import '../bloc/forms_bloc.dart';
import 'package:workorder_company_app/shared/widgets/select_buttom_sheet.dart';

class FormsSelector extends StatelessWidget {
  const FormsSelector({
    super.key,
    required this.selectedServiceForms,
    required this.onAdd,
    required this.onRemove,
    required this.onReorder,
    this.itemBuilder,
  });

  final List<ServiceFormEntity> selectedServiceForms;
  final void Function(ServiceFormEntity) onAdd;
  final void Function(ServiceFormEntity) onRemove;
  final void Function(int oldIndex, int newIndex) onReorder;
  final Widget Function(ServiceFormEntity serviceForm)? itemBuilder;

  Future<void> _openFormSelector(
    BuildContext context,
    List<FormEntity> forms,
    bool isLoading,
  ) async {
    if (isLoading) return;

    final form = await showModalBottomSheet<FormEntity>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SelectBottomSheet<FormEntity>(
        title: 'Pilih Form',
        items: forms,
        itemLabel: (form) => form.title,
        isLoading: isLoading,
        onSelect: (selected) => Navigator.pop(context, selected),
      ),
    );

    if (form != null &&
        !selectedServiceForms.any((f) => f.form.id == form.id)) {
      final newOrder = ServiceFormEntity(
        order: selectedServiceForms.length + 1,
        fillableByRoles: [UserRole.managerCompany],
        fillableByPositions: [],
        viewableByRoles: [UserRole.managerCompany],
        viewableByPositions: [],
        form: form,
      );
      onAdd(newOrder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormsBloc, FormsState>(
      builder: (context, state) {
        final isLoading = state is FormsLoading;
        final forms = state is FormsLoaded ? state.forms : <FormEntity>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Form",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                OutlinedButton.icon(
                  icon: const Icon(Icons.add),
                  label: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Tambah Form'),
                  onPressed: isLoading
                      ? null
                      : () => _openFormSelector(context, forms, isLoading),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (selectedServiceForms.isEmpty)
              const Text('Belum ada form yang dipilih')
            else
              ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                proxyDecorator: (child, index, animation) {
                  return Material(
                    color: Colors.transparent,
                    elevation: 0,
                    child: child,
                  );
                }, 
                onReorder: onReorder,
                children: [
                  for (final formOrder in selectedServiceForms)
                    itemBuilder != null
                        ? KeyedSubtree(
                            key: ValueKey(formOrder.form.id),
                            child: Builder(
                              builder: (context) => itemBuilder!(formOrder),
                            ),
                          )
                        : ListTile(
                            key: ValueKey(formOrder.form.id),
                            title: Text(formOrder.form.title),
                            trailing: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => onRemove(formOrder),
                            ),
                          ),
                ],
              )
          ],
        );
      },
    );
  }
}
