part of 'submission_bloc.dart';

sealed class SubmissionEvent {}

class FetchServiceForm extends SubmissionEvent {
  final String serviceId;
  FetchServiceForm(this.serviceId);
}
