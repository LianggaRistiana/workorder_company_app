part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class UserRegistrationSuccess extends AuthState {
}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final Failure? failure;
  AuthError(this.message, {this.failure});
}
