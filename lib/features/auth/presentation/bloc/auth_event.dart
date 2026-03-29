part of 'auth_bloc.dart';

sealed class AuthEvent {}

class AuthCheckStatus extends AuthEvent {}

class GetCurrentUserRequested extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class CompanyRegistrationRequested extends AuthEvent {
  final CompanyRegistrationEntity registrationData;

  CompanyRegistrationRequested(this.registrationData);
}

class UserRegistrationRequested extends AuthEvent {
  final UserRegistrationEntity registrationData;

  UserRegistrationRequested(this.registrationData);
}

class LogoutRequested extends AuthEvent {}
