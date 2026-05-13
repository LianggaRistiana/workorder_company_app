abstract class AccountPairingState {
  const AccountPairingState();
}

class AccountPairingInitial extends AccountPairingState {
  const AccountPairingInitial();
}

/// from backend: user request pairing → get redirect URL
class AccountPairingWaitingRedirect extends AccountPairingState {
  final String redirectUrl;

  const AccountPairingWaitingRedirect(this.redirectUrl);
}

/// waiting callback from external page (deep link)
class AccountPairingWaitingExternalResult extends AccountPairingState {
  const AccountPairingWaitingExternalResult();
}

/// waiting backend confirm final status
class AccountPairingWaitingCompletion extends AccountPairingState {
  const AccountPairingWaitingCompletion();
}

class AccountPairingSuccess extends AccountPairingState {
  final String message;

  const AccountPairingSuccess({required this.message});
}

class AccountPairingFailure extends AccountPairingState {
  final String message;

  const AccountPairingFailure(this.message);
}