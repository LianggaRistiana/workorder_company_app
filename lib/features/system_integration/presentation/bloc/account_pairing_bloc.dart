import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/account_pairing_event.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/account_pairing_state.dart';

class AccountPairingBloc
    extends Bloc<AccountPairingEvent, AccountPairingState> {
  final AppLinks appLinks;
  StreamSubscription? _sub;

  AccountPairingBloc(this.appLinks) : super(const AccountPairingInitial()) {
    on<AccountPairingStarted>(_onStarted);
    on<AccountPairingRedirectReceived>(_onRedirectReceived);
    on<AccountPairingExternalResultReceived>(_onExternalResult);
    on<AccountPairingCompleted>(_onCompleted);
    on<AccountPairingFailed>(_onFailed);

    _initDeepLinkListener();
  }

  void _initDeepLinkListener() {
    _sub = appLinks.uriLinkStream.listen((uri) {
      if (uri.host == 'pair' && uri.path == '/callback') {
        add(AccountPairingExternalResultReceived(
          code: uri.queryParameters['code'] ?? '',
          state: uri.queryParameters['state'] ?? '',
        ));
      }
    });
  }

  Future<void> _onStarted(
    AccountPairingStarted event,
    Emitter emit,
  ) async {
    emit(const AccountPairingInitial());

    try {
      // call backend → get redirect url
      final redirectUrl = await Future.value("https://google.com");
      await Future.delayed(const Duration(seconds: 3));
      emit(AccountPairingWaitingRedirect(redirectUrl)); // Success
      await Future.delayed(const Duration(seconds: 3));
      emit(const AccountPairingWaitingExternalResult());
    } catch (e) {
      emit(AccountPairingFailure(e.toString()));
    }
  }

  void _onRedirectReceived(
    AccountPairingRedirectReceived event,
    Emitter emit,
  ) {
    emit(AccountPairingWaitingExternalResult());
  }

  void _onExternalResult(
    AccountPairingExternalResultReceived event,
    Emitter emit,
  ) async {
    emit(const AccountPairingWaitingCompletion());
    await Future.delayed(const Duration(seconds: 3));
    emit(const AccountPairingSuccess(message: "Pairing success"));
  }

  Future<void> _onCompleted(
    AccountPairingCompleted event,
    Emitter emit,
  ) async {
    emit(const AccountPairingSuccess(message: "Pairing success"));
  }

  void _onFailed(
    AccountPairingFailed event,
    Emitter emit,
  ) {
    emit(AccountPairingFailure(event.message));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
