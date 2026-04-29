import 'dart:math';

import 'package:workorder_company_app/core/services/logger/app_logger.dart';

class RetryHelper {
  static Future<T> retryWithJitter<T>(
    Future<T> Function() task, {
    int maxAttempts = 5,
    Duration baseDelay = const Duration(seconds: 1),
    bool Function(Object error)? shouldRetry,
  }) async {
    final random = Random();

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await task();
      } catch (e) {
        if (attempt == maxAttempts) rethrow;

        if (shouldRetry != null && !shouldRetry(e)) {
          rethrow;
        }

        final jitter = random.nextInt(1000);
        final delay = baseDelay * pow(2, attempt);

        await Future.delayed(delay + Duration(milliseconds: jitter));
      }
    }

    appLogger.e(
        "Retry failed after $maxAttempts attempts performed by retry helper");
    throw Exception("Retry failed");
  }
}
