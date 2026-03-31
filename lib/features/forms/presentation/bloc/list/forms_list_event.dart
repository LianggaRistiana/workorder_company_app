part of 'forms_list_bloc.dart';

sealed class FormsListEvent {}

/// Event utama untuk fetch semua forms
class GetFormsListRequested extends FormsListEvent {
  final bool forceRefresh;

  GetFormsListRequested({this.forceRefresh = false});
}