import 'package:equatable/equatable.dart';

enum ServiceCreateStatus {
  initial,
  loading,
  success,
  error,
}

class ServiceCreateState extends Equatable {
  final ServiceCreateStatus status;
  final String? errorMessage;
  // final ServiceEntity? createdService;

  const ServiceCreateState({
    required this.status,
    this.errorMessage,
    // this.createdService,
  });

  ServiceCreateState copyWith({
    ServiceCreateStatus? status,
    String? errorMessage,
    // ServiceEntity? createdService,
  }) {
    return ServiceCreateState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      // createdService: createdService ?? this.createdService,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        // createdService,
      ];
}
