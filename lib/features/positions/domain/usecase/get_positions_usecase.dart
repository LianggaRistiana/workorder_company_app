import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/domain/repositories/positions_repository.dart';

class GetPositionsUsecase {
  final PositionsRepository _repository;

  GetPositionsUsecase(this._repository);

  Future<Either<Failure, List<PositionEntity>>> call() {
    return _repository.getPositions();
  }
}
