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

class OtpVerificationRequested extends AuthEvent {
  final OtpVerificationEntity data;

  OtpVerificationRequested(this.data);
}

class OtpResendRequested extends AuthEvent {
  final String email;

  OtpResendRequested(this.email);
}

class LogoutRequested extends AuthEvent {}
