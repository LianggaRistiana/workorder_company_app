import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/auth/domain/entities/company_registration_entity.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_registration_entity.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/company_registration_usecase.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/user_registration_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final LogoutUsecase logoutUsecase;
  final UserRegistrationUsecase userRegistrationUsecase;
  final CompanyRegistrationUsecase companyRegistrationUsecase;

  AuthBloc(
      {required this.loginUseCase,
      required this.getCurrentUserUsecase,
      required this.logoutUsecase,
      required this.userRegistrationUsecase,
      required this.companyRegistrationUsecase})
      : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<AuthCheckStatus>(_onAuthCheckStatus);
    on<LogoutRequested>(_onLogoutRequested);
    on<UserRegistrationRequested>(_onUserRegistrationRequested);
    on<CompanyRegistrationRequested>(_onCompanyRegistrationRequested);
    on<GetCurrentUserRequested>(_onGetCurrentUserRequested);
    // nanti bisa tambahkan register & logout handler
  }

  Future<void> _onGetCurrentUserRequested(
    GetCurrentUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await getCurrentUserUsecase(refresh: true);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user!)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await logoutUsecase();
    result.fold(
      (failure) => emit(Unauthenticated()),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onAuthCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final user = await getCurrentUserUsecase();
    user.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUseCase(LoginParams(
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onUserRegistrationRequested(
    UserRegistrationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await userRegistrationUsecase(event.registrationData);

    result.fold(
      (failure) => emit(AuthError(failure.message, failure: failure)),
      (_) => emit(UserRegistrationSuccess()),
    );
  }

  Future<void> _onCompanyRegistrationRequested(
    CompanyRegistrationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await companyRegistrationUsecase(event.registrationData);
    result.fold(
      (failure) => emit(AuthError(failure.message, failure: failure)),
      (_) => emit(CompanyRegistrationSuccess()),
    );
  }
}
