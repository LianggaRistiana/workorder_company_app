import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';

class WorkReportsFilledFormEntity extends Equatable {
  final List<FilledFormEntity> filledForms;

  List<String> get formsTitle => filledForms.map((e) => e.form.title).toList();

  const WorkReportsFilledFormEntity({
    required this.filledForms,
  });

  @override
  List<Object?> get props => [
        filledForms,
      ];
}
