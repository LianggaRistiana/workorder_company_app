import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/cache/cacheable.dart';
import 'package:workorder_company_app/core/services/cache/streamable_cache.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

abstract class PositionsRepository implements Cacheable, StreamableCache {
  Future<Either<Failure, List<PositionEntity>>> getPositions({bool refresh});
  FutureEitherWithMeta<PositionEntity> getPositionById(String id);
  Future<Either<Failure, PositionEntity>> createPostion(
      PositionEntity position);
  Future<Either<Failure, PositionEntity>> updatePosition(
      PositionEntity position);
  FutureEither<Empty> deletePosition(PositionEntity position);
}
