import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:workorder_company_app/core/services/deep_links/deep_link_data.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';

class DeepLinkService {
  DeepLinkService(this._appLinks);

  final AppLinks _appLinks;

  final StreamController<DeepLinkData> _controller =
      StreamController.broadcast();

  StreamSubscription<Uri>? _subscription;

  Stream<DeepLinkData> get stream => _controller.stream;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    _initialized = true;

    try {
      final initialUri = await _appLinks.getInitialLink();

      if (initialUri != null) {
        _handleUri(initialUri);
      }

      _subscription = _appLinks.uriLinkStream.listen(
        _handleUri,
        onError: (error, stackTrace) {
          appLogger.e('Deep link error: $error');
        },
      );
    } catch (error) {
      appLogger.e('Deep link init error: $error');
    }
  }

  void _handleUri(Uri uri) {
    // debugPrint('Incoming deep link: $uri');

    final deepLink = _mapUri(uri);

    _controller.add(deepLink);
  }

  DeepLinkData _mapUri(Uri uri) {
    /// com.workorder.saas://pair/callback?code=xxx&state=yyy

    if (uri.host == 'pair' && uri.path == '/callback') {
      return PairCallbackDeepLinkData(
        uri: uri,
        code: uri.queryParameters['code'],
        state: uri.queryParameters['state'],
        companyId: uri.queryParameters['companyId'],
      );
    }

    return DeepLinkData(
      type: DeepLinkType.unknown,
      uri: uri,
    );
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _controller.close();
  }
}
