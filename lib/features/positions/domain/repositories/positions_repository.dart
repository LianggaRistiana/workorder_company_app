import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

abstract class PositionsRepository {
  Future<Either<Failure, List<PositionEntity>>> getPositions();
  Future<Either<Failure, PositionEntity>> getPositionById(String id);
  Future<Either<Failure, PositionEntity>> createPostion(PositionEntity position);
  Future<Either<Failure, PositionEntity>> updatePosition(PositionEntity position);
}
