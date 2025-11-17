part of 'csr_bloc.dart';

enum CsrStateStatus {
  initial,
  loading,
  loaded,
  error,
}


class CsrState extends Equatable {
  final CsrStateStatus status;
  final List<ClientServiceRequestEntity> clientServiceRequests;
  final String? errorMessage;

  const CsrState({
    this.status = CsrStateStatus.initial,
    this.clientServiceRequests = const [],
    this.errorMessage,
  });

  CsrState copyWith({
    CsrStateStatus? status,
    List<ClientServiceRequestEntity>? clientServiceRequests,
    String? errorMessage,
  }) {
    return CsrState(
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
