import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';

abstract class AccountPairingEvent {
  const AccountPairingEvent();
}

/// user start pairing request
class AccountPairingStarted extends AccountPairingEvent {
  final String companyId;

  const AccountPairingStarted(
    this.companyId,
  );
}

/// backend returns redirect link
class AccountPairingRedirectReceived extends AccountPairingEvent {
  final String url;

  const AccountPairingRedirectReceived(this.url);
}

class AccountRedirectLoginStarted extends AccountPairingEvent {
  const AccountRedirectLoginStarted();
}

/// external page callback (deep link)
class AccountPairingExternalResultReceived extends AccountPairingEvent {
  final String code;
  final String state;

  const AccountPairingExternalResultReceived({
    required this.code,
    required this.state,
  });
}

class AccountPairngCompletionStarted extends AccountPairingEvent {
  final String companyId;
  final String code;
  final String state;

  const AccountPairngCompletionStarted({
    required this.companyId,
    required this.code,
    required this.state,
  });
}

/// backend confirm final status
class AccountPairingCompleted extends AccountPairingEvent {
  final ExternalUserEntity account;

  const AccountPairingCompleted(
    this.account,
  );
}

class AccountPairingFailed extends AccountPairingEvent {
  final String message;

  const AccountPairingFailed(this.message);
}
