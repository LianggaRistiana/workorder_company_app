part of 'csr_bloc.dart';

sealed class CsrEvent {}

class GetClientServiceRequestsRequested extends CsrEvent {}

class GetClientServiceRequestDetailRequested extends CsrEvent {}
