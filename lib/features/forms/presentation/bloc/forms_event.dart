part of 'forms_bloc.dart';

sealed class FormsEvent {}

class GetFormsRequested extends FormsEvent {}

class GetFormByIdRequested extends FormsEvent {
  final String id;
  GetFormByIdRequested(this.id);
}
