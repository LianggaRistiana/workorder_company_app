import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/domain/repositories/positions_repository.dart';

class UpdatePositionUsecase {
  final PositionsRepository _repository;

  UpdatePositionUsecase(this._repository);

  Future<Either<Failure, PositionEntity>> call(PositionEntity position) {
    return _repository.updatePosition(position);
  }
}
