import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message; // optional pesan error
  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = "Server error occurred"});
}

class ParsingFailure extends Failure {
  const ParsingFailure(
      {super.message = "Terjadi kesalahan dalam data yang diterima"});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = "Cache error occurred"});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = "Unexpected error occurred"});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = "No internet connection"});
}

class AuthFailure extends Failure {
  const AuthFailure({super.message = "Unauthorize"});
}

class PolicyFailure<E> extends Failure {
  final E error;

  const PolicyFailure(
    this.error, {
    super.message = "Policy validation failed",
  });

  @override
  List<Object?> get props => [error, message];
}
