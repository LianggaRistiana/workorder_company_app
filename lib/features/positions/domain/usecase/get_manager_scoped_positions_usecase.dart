import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class GetManagerScopedPositionUsecase {
  final AuthRepository repository;

  GetManagerScopedPositionUsecase(this.repository);

  PositionEntity? call() {
    final user = repository.currentUser;
    if (user == null) {
      return null;
    } else if (user.role != UserRole.managerCompany) {
      return null;
    } else {
      return user.position;
    }
  }
}
