import 'package:equatable/equatable.dart';

enum ServiceUpdateStatus {
  initial,
  loading,
  success,
  error,
}


class ServiceUpdateState extends Equatable {
  final ServiceUpdateStatus status;
  final String? errorMessage;

  const ServiceUpdateState({
    required this.status,
    this.errorMessage,
  });

  ServiceUpdateState copyWith({
    ServiceUpdateStatus? status,
    String? errorMessage,
  }) {
    return ServiceUpdateState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        // createdService,
      ];
}
