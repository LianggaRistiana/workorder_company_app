import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/notification/domain/repositories/notification_repository.dart';

class LogoutUsecase {
  final AuthRepository repository;
  final NotificationRepository notificationRepository;

  LogoutUsecase(this.repository, this.notificationRepository);

  Future<Either<Failure, void>> call() async {
    // FIXME[Medium] : clear all cache when logout
    await notificationRepository
        .dispose(); // HACK : if logout fail notification still dispose
    return repository.logOut();
  }
}
