import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/cache/cache_registry.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';

class LogoutUsecase {
  final AuthRepository _authRepository;
  final NotificationRepository _notificationRepository;
  final CacheRegistry _cacheRegistry;

  LogoutUsecase(
      this._authRepository, this._notificationRepository, this._cacheRegistry);

  Future<Either<Failure, void>> call() async {
    // FIXME[Medium] : clear all cache when logout
    await _notificationRepository.dispose();
    _cacheRegistry.clearAll();
    return _authRepository.logOut();
  }
}
