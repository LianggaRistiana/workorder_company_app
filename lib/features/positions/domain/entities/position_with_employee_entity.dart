import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class PositionWithEmployeeEntity {
  List<PositionEntity> position;
  List<UserEntity> employees;

  PositionWithEmployeeEntity({
    required this.position,
    required this.employees,
  });
}
