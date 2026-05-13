import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/services/deep_links/deep_link_data.dart';
import 'package:workorder_company_app/core/services/deep_links/deep_links_service.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

abstract class DeepLinkHandler {
  Future<void> handle(DeepLinkData data);
}

class PairCallbackDeepLinkHandler implements DeepLinkHandler {
  final GoRouter router;

  const PairCallbackDeepLinkHandler({
    required this.router,
  });

  @override
  Future<void> handle(DeepLinkData data) async {
    final deepLink = data as PairCallbackDeepLinkData;

    final code = deepLink.code;
    final state = deepLink.state;

    appLogger.i('Pair callback received\nCode: $code\nState: $state');

    if (code == null || code.isEmpty) {
      appLogger.e('Invalid pair callback code');

      return;
    }

    appLogger.i('redirecting');
    router.push(AppRoutes.pairAccount, extra: deepLink);
  }
}

class UnknownDeepLinkHandler implements DeepLinkHandler {
  const UnknownDeepLinkHandler();

  @override
  Future<void> handle(DeepLinkData data) async {
    appLogger.e('Unknown deep link: ${data.uri}');
  }
}

class DeepLinkCoordinator {
  DeepLinkCoordinator({
    required DeepLinkService deepLinkService,
    required PairCallbackDeepLinkHandler pairCallbackHandler,
    required UnknownDeepLinkHandler unknownHandler,
  })  : _deepLinkService = deepLinkService,
        _pairCallbackHandler = pairCallbackHandler,
        _unknownHandler = unknownHandler;

  final DeepLinkService _deepLinkService;

  final PairCallbackDeepLinkHandler _pairCallbackHandler;
  final UnknownDeepLinkHandler _unknownHandler;

  StreamSubscription<DeepLinkData>? _subscription;

  Future<void> start() async {
    _subscription = _deepLinkService.stream.listen(_onDeepLink);
  }

  Future<void> _onDeepLink(DeepLinkData data) async {
    switch (data.type) {
      case DeepLinkType.pairCallback:
        await _pairCallbackHandler.handle(data);

        break;

      case DeepLinkType.unknown:
        await _unknownHandler.handle(data);

        break;
    }
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}
