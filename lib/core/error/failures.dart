import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/model/property_key.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = "Server error occurred"});
}

class ValidationFailure extends Failure {
  final Map<String, String> errors;

  const ValidationFailure({
    required this.errors,
    super.message = "Validation failed",
  });

  @override
  List<Object?> get props => [errors, message];

  String? errorOf(PropertyKey property) {
    return errors[property.key];
  }
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

extension FailureX on Failure? {
  String? validationErrorOf(PropertyKey property) {
    if (this is ValidationFailure) {
      return (this as ValidationFailure).errorOf(property);
    }
    return null;
  }
}
