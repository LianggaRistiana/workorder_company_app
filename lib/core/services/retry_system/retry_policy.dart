import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';

class RetryPolicy {
  static bool shouldRetry(Object error) {
    if (error is ApiException) {
      return error.statusCode == 408 ||
          error.statusCode == 503 ||
          error.statusCode == -1;
    }
    appLogger.e("Blocked by retry policy: $error");
    return false;
  }
}
