import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/services/domain/entities/form_order_entity.dart';
import '../../domain/entities/form_entity.dart';
import '../bloc/forms_bloc.dart';
import 'package:workorder_company_app/shared/widgets/select_buttom_sheet.dart';

class FormsSelector extends StatelessWidget {
  const FormsSelector({
    super.key,
    required this.selectedFormsOrder,
    required this.onAdd,
    required this.onRemove,
    required this.onReorder,
  });

  final List<FormOrderEntity> selectedFormsOrder;
  final void Function(FormOrderEntity) onAdd;
  final void Function(FormOrderEntity) onRemove;
  final void Function(int oldIndex, int newIndex) onReorder;

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
        !selectedFormsOrder.any((f) => f.form.id == form.id)) {
      final newOrder = FormOrderEntity(
        order: selectedFormsOrder.length + 1,
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
            if (selectedFormsOrder.isEmpty)
              const Text('Belum ada form yang dipilih')
            else
              ReorderableListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                onReorder: onReorder,
                children: [
                  for (final formOrder in selectedFormsOrder)
                    ListTile(
                      key: ValueKey(formOrder.form.id),
                      title: Text(formOrder.form.title),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => onRemove(formOrder),
                      ),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}
