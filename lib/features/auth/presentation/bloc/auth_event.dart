part of 'auth_bloc.dart';

sealed class AuthEvent {}

class AuthCheckStatus extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  RegisterRequested(this.name, this.email, this.password);
}

class CompanyRegistrationRequested extends AuthEvent {}

class UserRegistrationRequested extends AuthEvent {
  final UserRegistrationEntity registrationData;

  UserRegistrationRequested(this.registrationData);
}

class LogoutRequested extends AuthEvent {}
