import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';

class FilledFormModel extends FilledFormEntity {
  const FilledFormModel({
    required super.form,
    super.submission,
  });

  factory FilledFormModel.fromJson(Map<String, dynamic> json) {
    return FilledFormModel(
      form: FormModel.fromJson(json['form']),
      submission: SubmissionsModel.fromJson(json['submission']),
    );
  }

  FilledFormEntity toEntity() {
    return FilledFormEntity(
      form: form,
      submission: submission,
    );
  }
}
