import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:workorder_company_app/features/auth/domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final GetCurrentUserUsecase getCurrentUserUsecase;

  AuthBloc({required this.loginUseCase, required this.getCurrentUserUsecase})
      : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<AuthCheckStatus>(_onAuthCheckStatus);
    // nanti bisa tambahkan register & logout handler
  }

  Future<void> _onAuthCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    // try {
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
}
