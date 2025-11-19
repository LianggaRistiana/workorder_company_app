import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';

class FilledFormModel extends FilledFormEntity{
  const FilledFormModel({
    super.order,
    required super.form,
    super.submission,
  });

  factory FilledFormModel.fromJson(Map<String, dynamic> json) {
    return FilledFormModel(
      order: safeParse<int>(json, "order"),
      form: FormModel.fromJson(json['form']),
      submission: SubmissionsModel.fromJson(json['submission']),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'order': order,
  //     'form': (form as FormModel).toJson(),
  //     'submission': (submission as SubmissionModel).toJson(),
  //   };
  // }
}