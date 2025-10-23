part of 'submission_bloc.dart';

sealed class SubmissionEvent {}

class FetchServiceForm extends SubmissionEvent {
  final String serviceId;
  FetchServiceForm(this.serviceId);
}

class SubmitIntakeForm extends SubmissionEvent {
  final String serviceId;
  final List<SubmissionEntity> submissions;
  SubmitIntakeForm(this.serviceId, this.submissions);
}
