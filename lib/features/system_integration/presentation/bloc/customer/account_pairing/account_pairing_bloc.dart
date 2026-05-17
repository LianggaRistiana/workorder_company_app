import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/complete_pairing_usecase.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/start_pairing_usecase.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/customer/account_pairing/account_pairing_event.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/customer/account_pairing/account_pairing_state.dart';

class AccountPairingBloc
    extends Bloc<AccountPairingEvent, AccountPairingState> {
  final StartPairingUsecase _startPairingUsecase;
  final CompletePairingUsecase _completePairingUsecase;
  final AppLinks appLinks;

  StreamSubscription<Uri>? _sub;

  String? _companyId;
  bool _isWaitingPairingResult = false;

  AccountPairingBloc(
    this._startPairingUsecase,
    this._completePairingUsecase,
    this.appLinks,
  ) : super(const AccountPairingInitial()) {
    on<AccountPairingStarted>(_onStarted);
    on<AccountRedirectLoginStarted>(_onRedirectStarted);
    on<AccountPairingExternalResultReceived>(_onExternalResult);
    on<AccountPairingCompleted>(_onCompleted);
    on<AccountPairingFailed>(_onFailed);

    _initializeDeepLink();
  }

  Future<void> _initializeDeepLink() async {
    await _sub?.cancel();

    final initialUri = await appLinks.getInitialLink();

    if (initialUri != null) {
      _handleUri(initialUri);
    }

    _sub = appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (_) {
        add(
          const AccountPairingFailed(
            "Gagal membaca deep link",
          ),
        );
      },
    );
  }

  void _handleUri(Uri uri) {
    if (!_isWaitingPairingResult) return;

    final isPairCallback = uri.host == 'pair' && uri.path == '/callback';

    if (!isPairCallback) return;

    final code = uri.queryParameters['code'];
    final state = uri.queryParameters['state'];

    if (code == null || state == null) {
      add(
        const AccountPairingFailed(
          "Data callback tidak valid",
        ),
      );
      return;
    }

    add(
      AccountPairingExternalResultReceived(
        code: code,
        state: state,
      ),
    );
  }

  Future<void> _onStarted(
    AccountPairingStarted event,
    Emitter<AccountPairingState> emit,
  ) async {
    emit(const AccountPairingInitial());

    _companyId = event.companyId;

    final result = await _startPairingUsecase(event.companyId);

    result.fold(
      (failure) {
        emit(
          AccountPairingFailure(
            failure.message,
          ),
        );
      },
      (data) {
        emit(
          AccountPairingWaitingRedirect(
            data.redirectUrl,
          ),
        );
      },
    );
  }

  void _onRedirectStarted(
    AccountRedirectLoginStarted event,
    Emitter<AccountPairingState> emit,
  ) {
    _isWaitingPairingResult = true;

    emit(
      const AccountPairingWaitingExternalResult(),
    );
  }

  Future<void> _onExternalResult(
    AccountPairingExternalResultReceived event,
    Emitter<AccountPairingState> emit,
  ) async {
    if (_companyId == null) {
      emit(
        const AccountPairingFailure("Company tidak ditemukan"),
      );
      return;
    }

    emit(
      const AccountPairingWaitingCompletion(),
    );

    final result = await _completePairingUsecase(
      companyId: _companyId!,
      code: event.code,
      state: event.state,
    );

    result.fold(
      (failure) {
        add(
          AccountPairingFailed(
            failure.message,
          ),
        );
      },
      (data) {
        add(
          AccountPairingCompleted(data),
        );
      },
    );
  }

  Future<void> _onCompleted(
    AccountPairingCompleted event,
    Emitter<AccountPairingState> emit,
  ) async {
    _isWaitingPairingResult = false;

    emit(
      AccountPairingSuccess(
        account: event.account,
        message: "Berhasil menghubungkan akun",
      ),
    );
  }

  void _onFailed(
    AccountPairingFailed event,
    Emitter<AccountPairingState> emit,
  ) {
    _isWaitingPairingResult = false;

    emit(
      AccountPairingFailure(
        event.message,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
