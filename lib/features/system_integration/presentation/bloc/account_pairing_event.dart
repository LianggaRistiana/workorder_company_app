abstract class AccountPairingEvent {
  const AccountPairingEvent();
}

/// user start pairing request
class AccountPairingStarted extends AccountPairingEvent {
  const AccountPairingStarted();
}

/// backend returns redirect link
class AccountPairingRedirectReceived extends AccountPairingEvent {
  final String url;

  const AccountPairingRedirectReceived(this.url);
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

/// backend confirm final status
class AccountPairingCompleted extends AccountPairingEvent {
  const AccountPairingCompleted();
}

class AccountPairingFailed extends AccountPairingEvent {
  final String message;

  const AccountPairingFailed(this.message);
}