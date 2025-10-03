part of 'forms_bloc.dart';

sealed class FormsState extends Equatable {
  const FormsState();

  @override
  List<Object?> get props => [];
}

class FormsIntial extends FormsState {}

class FormsLoading extends FormsState {}

class FormsLoaded extends FormsState {
  final List<FormEntity> forms;

  const FormsLoaded(this.forms);
}

class FormsError extends FormsState {
  final String message;

  const FormsError(this.message);
  @override
  List<Object?> get props => [message];
}
