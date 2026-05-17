import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class GetCurrentUserPositionsUsecase {
  final AuthRepository repository;

  GetCurrentUserPositionsUsecase(this.repository);

  PositionEntity? call() {
    final user = repository.currentUser;
    return user?.position;
  }
}
