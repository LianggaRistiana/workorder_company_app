enum DeepLinkType {
  pairCallback,
  unknown,
}

class DeepLinkData {
  final DeepLinkType type;
  final Uri uri;

  const DeepLinkData({
    required this.type,
    required this.uri,
  });
}

class PairCallbackDeepLinkData extends DeepLinkData {
  final String? code;
  final String? state;
  final String? companyId;

  const PairCallbackDeepLinkData({
    required super.uri,
    required this.code,
    required this.state,
    required this.companyId,
  }) : super(
          type: DeepLinkType.pairCallback,
        );
}
