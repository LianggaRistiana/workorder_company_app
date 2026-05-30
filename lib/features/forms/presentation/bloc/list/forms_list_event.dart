part of 'forms_list_bloc.dart';

sealed class FormsListEvent {}

class GetFormsListRequested extends FormsListEvent {
  final bool forceRefresh;

  GetFormsListRequested({this.forceRefresh = false});
}


class SetFormFilter extends FormsListEvent {
  final FormParams filter;

  SetFormFilter(this.filter);
}