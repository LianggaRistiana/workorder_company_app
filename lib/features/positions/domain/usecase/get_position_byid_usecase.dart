import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/domain/repositories/positions_repository.dart';

class GetPositionByidUsecase {
  final PositionsRepository repository;

  GetPositionByidUsecase(this.repository);

  Future<Either<Failure, PositionEntity>> call(String id) async {
    return await repository.getPositionById(id);
  }
}
