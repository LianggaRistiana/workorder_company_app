import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/features/forms/data/model/field_model.dart';
import 'package:workorder_company_app/features/forms/data/model/option_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/submissions/data/model/field_data_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/submissions/presentation/coordinator/form_renderer_coordinator.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/form_renderer.dart';

final mockForm = FilledFormEntity(
  form: const FormEntity(
    id: "intake-service-1",
    title: "Intake Form",
    description: "Please fill out the details of your request",
    formType: FormType.intake,
    fields: [
      FieldModel(
        order: 1,
        label: "Problem Description",
        type: FieldType.textarea,
        required: true,
        placeholder: "Describe the issue...",
      ),
      FieldModel(
        order: 2,
        label: "Priority",
        type: FieldType.singleSelect,
        required: true,
        options: [
          OptionModel(key: "high", value: "High"),
          OptionModel(key: "medium", value: "Medium"),
          OptionModel(key: "low", value: "Low"),
        ],
      ),
      FieldModel(
        order: 3,
        label: "Preferred Date",
        type: FieldType.date,
        required: false,
      ),
      FieldModel(
        order: 4,
        label: "Bukti Pembayaran",
        type: FieldType.image,
        required: true,
        placeholder: "Describe the issue...",
      ),
    ],
  ),
  submission: SubmissionsModel(
    id: "sub-1",
    formId: "intake-service-1",
    submissionType: FormType.intake,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    fieldsData: [
      FieldDataModel(
        order: "1",
        value: "The hall needs a deep clean, lots of dust.",
      ),
      FieldDataModel(
        order: "2",
        value: "high",
      ),
      FieldDataModel(
        order: "3",
        value: DateTime.now(),
      ),
      FieldDataModel(
        order: "4",
        value:
            "https://bucket-production-2556.up.railway.app/workorder/f74360c7-1b6c-4639-8546-f4d56d4b3adf.webp",
      ),
    ],
  ),
);

class LabPage extends StatefulWidget {
  const LabPage({super.key});

  @override
  State<LabPage> createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  late final FormRendererCoordinator coordinator;

  @override
  void initState() {
    coordinator = FormRendererCoordinator.filledForm(mockForm);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.print),
            onPressed: () => appLogger.i(coordinator.draft.fieldsData
                .map((val) => val.value)
                .toString())),
        body: SingleChildScrollView(
            child: FormRenderer(coordinator: coordinator)));
  }
}
