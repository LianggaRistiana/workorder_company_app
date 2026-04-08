import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/submissions/presentation/coordinator/form_renderer_coordinator.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/field_renderer.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';

class FormRenderer extends StatefulWidget {
  final FormRendererCoordinator coordinator;
  final bool isReadOnly;
  // final void Function(String formId, String order, dynamic value) onChanged;

  const FormRenderer({
    super.key,
    required this.coordinator,
    this.isReadOnly = false,
    // required this.onChanged
  });

  @override
  State<FormRenderer> createState() => _FormRendererState();
}

class _FormRendererState extends State<FormRenderer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCard(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.all(4),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.center,
                    colors: [
                      Theme.of(context).colorScheme.primaryFixedDim,
                      Theme.of(context).colorScheme.primary,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: const SizedBox(
                  height: 1,
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.coordinator.form.title,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(widget.coordinator.form.description,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ])),
            ])),
        const SizedBox(height: 16),
        CustomList<FieldEntity>(
          items: widget.coordinator.form.fields ?? [],
          separatorHeight: 12,
          itemBuilder: (field, _) => FieldRenderer(
              // formId: widget.coordinator.form.id,
              field: field,
              onChanged: widget.coordinator.updateValue,
              value: widget.coordinator.draft
                  .getFieldByOrder(field.order.toString())),
        ),
      ],
    );
  }
}
