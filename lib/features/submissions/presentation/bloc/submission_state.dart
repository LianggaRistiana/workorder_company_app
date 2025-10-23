part of 'submission_bloc.dart';


sealed class SubmissionState {}

class IntialSubmissionState extends SubmissionState {}

class Loading extends SubmissionState {}

class ReadyToFill extends SubmissionState {
  final List<OrderedFormEntity> form;
  ReadyToFill(this.form);
}

class Error extends SubmissionState {
  final String message;
  Error(this.message);
}

class Success extends SubmissionState {}