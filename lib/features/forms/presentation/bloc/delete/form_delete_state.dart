import 'package:equatable/equatable.dart';

enum FormDeleteStatus {
  initial,
  loading,
  deleted,
  error,
}

class FormDeleteState extends Equatable{
  final FormDeleteStatus status;
  final String? errorMessage;

  const FormDeleteState({
    this.status = FormDeleteStatus.initial,
    this.errorMessage,
  });
  
  @override
  List<Object?> get props => [
    status,
    errorMessage,
  ];
}
