part of 'internal_csr_bloc.dart';

enum CsrStateStatus {
  initial,
  loading,
  loaded,
  error,
}

class InternalCsrState extends Equatable {
  final CsrStateStatus status;
  final List<ClientServiceRequestEntity> clientServiceRequests;
  final String? errorMessage;

  const InternalCsrState({
    this.status = CsrStateStatus.initial,
    this.clientServiceRequests = const [],
    this.errorMessage,
  });

  InternalCsrState copyWith({
    CsrStateStatus? status,
    List<ClientServiceRequestEntity>? clientServiceRequests,
    String? errorMessage,
  }) {
    return InternalCsrState(
      status: status ?? this.status,
      clientServiceRequests:
          clientServiceRequests ?? this.clientServiceRequests,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        clientServiceRequests,
        errorMessage,
      ];
}

class InternalCsrDetailState extends Equatable {
  final CsrStateStatus status;
  final ClientServiceRequestEntity? clientServiceRequest;
  final String? errorMessage;

  const InternalCsrDetailState({
    this.status = CsrStateStatus.initial,
    this.clientServiceRequest,
    this.errorMessage,
  });

  InternalCsrDetailState copyWith({
    CsrStateStatus? status,
    ClientServiceRequestEntity? clientServiceRequest,
    String? errorMessage,
  }) {
    return InternalCsrDetailState(
      status: status ?? this.status,
      clientServiceRequest: clientServiceRequest ?? this.clientServiceRequest,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        clientServiceRequest,
        errorMessage,
      ];
}

class InternalCsrActionsState extends Equatable {
  final String? workorderId;
  final String? errorMessage;
  final CsrStateStatus status;

  const InternalCsrActionsState({
    this.workorderId,
    this.errorMessage,
    this.status = CsrStateStatus.initial,
  });

  InternalCsrActionsState copyWith({
    String? workorderId,
    String? errorMessage,
    CsrStateStatus? status,
  }) {
    return InternalCsrActionsState(
      workorderId: workorderId ?? this.workorderId,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        workorderId,
        errorMessage,
        status,
      ];
}
