import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/meta/form_detail_meta.dart';

enum FormDetailStatus {
  initial,
  loading,
  loaded,
  error,
}

class FormDetailState extends Equatable {
  final FormDetailStatus status;
  final FormEntity? form;
  final String? errorMessage;
  final FormDetailMeta? meta;

  const FormDetailState({
    this.status = FormDetailStatus.initial,
    this.form,
    this.errorMessage,
    this.meta,
  });

  FormDetailState copyWith({
    FormDetailStatus? status,
    FormEntity? form,
    String? errorMessage,
    FormDetailMeta? meta,
  }) {
    return FormDetailState(
      status: status ?? this.status,
      form: form ?? this.form,
      errorMessage: errorMessage ?? this.errorMessage,
      meta: meta ?? this.meta,
    );
  }

  @override
  List<Object?> get props => [
        status,
        form,
        errorMessage,
        meta,
      ];
}
