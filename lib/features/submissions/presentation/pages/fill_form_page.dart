import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/field_data_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
import 'package:workorder_company_app/features/submissions/presentation/bloc/submission_bloc.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/multi_select_field_widget.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/number_form_field_widget.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/single_select_field_widget.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/text_form_field_widget.dart';


// TODO : FIX this name
class FillFormPage extends StatefulWidget {
  final String serviceId;

  const FillFormPage({super.key, required this.serviceId});

  @override
  State<FillFormPage> createState() => _FillFormPageState();
}

class _FillFormPageState extends State<FillFormPage> {
  final _formKey = GlobalKey<FormState>();
  List<SubmissionEntity> _submissions = [];

  void _initializeSubmissions(List<OrderedFormEntity> orderedForms) {
    if (_submissions.isEmpty) {
      _submissions = orderedForms
          .map(
            (orderedForm) => SubmissionEntity(
              id: '',
              formId: orderedForm.form.id,
              submissionType: FormType.intake,
              fieldsData: [],
            ),
          )
          .toList();
    }
  }

  void _onFieldChanged(String formId, String order, dynamic value) {
    final updatedSubmissions = List<SubmissionEntity>.from(_submissions);
    final formIndex = updatedSubmissions.indexWhere((s) => s.formId == formId);

    if (formIndex == -1) return; // safety

    final submission = updatedSubmissions[formIndex];
    final updatedFields =
        List<FieldDataEntity>.from(submission.fieldsData ?? []);
    final fieldIndex = updatedFields.indexWhere((f) => f.order == order);

    if (fieldIndex != -1) {
      updatedFields[fieldIndex] = FieldDataEntity(order: order, value: value);
    } else {
      updatedFields.add(FieldDataEntity(order: order, value: value));
    }

    updatedSubmissions[formIndex] =
        submission.copyWith(fieldsData: updatedFields);

    setState(() {
      _submissions = updatedSubmissions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<SubmissionBloc>()..add(FetchServiceForm(widget.serviceId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Isi Formulir')),
        body: BlocBuilder<SubmissionBloc, SubmissionState>(
          builder: (context, state) {
            if (state is Loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is Error) {
              return Center(child: Text('Error: ${state.message}'));
            }

            if (state is ReadyToFill) {
              final orderedForms = List<OrderedFormEntity>.from(state.form)
                ..sort((a, b) => a.order.compareTo(b.order));

              _initializeSubmissions(orderedForms);

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final orderedForm in orderedForms) ...[
                        Text(
                          orderedForm.form.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (orderedForm.form.description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              orderedForm.form.description,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        const SizedBox(height: 8),
                        for (final field in orderedForm.form.fields ?? []) ...[
                          _buildField(orderedForm.form.id, field),
                          const SizedBox(height: 16),
                        ],
                        const Divider(height: 32),
                      ],
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            sl<SubmissionBloc>().add(SubmitIntakeForm(
                                widget.serviceId, _submissions));
                            // for (final sub in _submissions) {
                            //   Logger().i(sub.toString());
                            // }
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //       content: Text('Dummy submit success!')),
                            // );
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildField(String formId, FieldEntity field) {
    switch (field.type) {
      case FieldType.text:
        return TextFormFieldWidget(
          field: field,
          onChanged: (val) =>
              _onFieldChanged(formId, field.order.toString(), val),
        );
      case FieldType.number:
        return NumberFormFieldWidget(
          field: field,
          onChanged: (val) =>
              _onFieldChanged(formId, field.order.toString(), val),
        );
      case FieldType.multiSelect:
        return MultiSelectFormFieldWidget(
          field: field,
          initialValue: [],
          onChanged: (vals) => _onFieldChanged(
            formId,
            field.order.toString(),
            vals.map((e) => e.key).toList(),
          ),
        );
      case FieldType.singleSelect:
        return SingleSelectFormFieldWidget(
          field: field,
          initialValue: null,
          onChanged: (val) =>
              _onFieldChanged(formId, field.order.toString(), val?.key),
        );
      default:
        return Text('Unsupported field type: ${field.type}');
    }
  }
}
