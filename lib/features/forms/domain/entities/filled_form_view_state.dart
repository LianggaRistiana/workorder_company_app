import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

class FilledFormViewState extends Equatable{
  final FormEntity form;
  final bool isLatest;
  final SubmissionEntity? submission;

  const FilledFormViewState({
    required this.form,
    required this.isLatest,
    required this.submission,
  });

  bool get isFilled => submission != null;
  
  @override
  List<Object?> get props => [
    form,
    submission,
    isLatest,
  ];
}
