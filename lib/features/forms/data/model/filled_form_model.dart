import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';

class FilledFormModel extends FilledFormEntity {
  FilledFormModel({required super.form, super.submission});

  factory FilledFormModel.fromJson(
      Map<String, dynamic> formJson, Map<String, dynamic>? submissionJson) {
    return FilledFormModel(
      form: FormModel.fromJson(formJson),
      submission: submissionJson == null
          ? null
          : SubmissionsModel.fromJson(submissionJson),
    );
  }
}
