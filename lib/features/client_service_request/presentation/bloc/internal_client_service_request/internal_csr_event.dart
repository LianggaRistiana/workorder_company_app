part of 'internal_csr_bloc.dart';

sealed class InternalCsrEvent {}

class GetClientServiceRequestsRequested extends InternalCsrEvent {}

class GetClientServiceRequestDetailRequested extends InternalCsrEvent {}