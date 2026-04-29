import 'package:workorder_company_app/core/services/logger/app_logger.dart';

class CircuitBreaker {
  int _failureCount = 0;
  DateTime? _lastFailureTime;

  final int failureThreshold;
  final Duration resetTimeout;

  CircuitBreaker({
    this.failureThreshold = 3,
    this.resetTimeout = const Duration(seconds: 30),
  });

  bool get isOpen {
    if (_failureCount < failureThreshold) return false;
    if (_lastFailureTime == null) return false;

    return DateTime.now().difference(_lastFailureTime!) < resetTimeout;
  }

  Future<T> call<T>(Future<T> Function() task) async {
    if (isOpen) {
      appLogger.e("Circuit breaker is OPEN");
      throw Exception("Circuit breaker is OPEN");
    }

    try {
      final result = await task();
      _failureCount = 0;
      return result;
    } catch (e) {
      _failureCount++;
      _lastFailureTime = DateTime.now();
      rethrow;
    }
  }

  void reset() {
    _failureCount = 0;
    _lastFailureTime = null;
  }
}
