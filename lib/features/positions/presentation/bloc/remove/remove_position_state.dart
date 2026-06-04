import 'package:equatable/equatable.dart';

enum RemovePositionStatus {
  initial,
  loading,
  error,
  deleted,
}

class RemovePositionState extends Equatable{
  final RemovePositionStatus status;
  final String? errorMessages;

  const RemovePositionState({
    this.status = RemovePositionStatus.initial,
    this.errorMessages,
  });
  
  @override
  List<Object?> get props => [
    status,
    errorMessages,
  ];
}
