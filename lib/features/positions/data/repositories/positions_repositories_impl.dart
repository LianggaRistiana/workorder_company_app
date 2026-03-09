import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/positions/data/datasources/positions_remote_datasource.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/domain/repositories/positions_repository.dart';

class PositionsRepositoryImpl implements PositionsRepository {
  final PositionsRemoteDatasource _remoteDatasource;

  PositionsRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<PositionEntity>>> getPositions() {
    return safeCall(() async {
      final response = await _remoteDatasource.getPositions();
      return response.data ?? [];
    });
  }

  @override
  Future<Either<Failure, PositionEntity>> createPostion(
      PositionEntity position) {
    return safeCall(() async {
      final payload = await _remoteDatasource
          .createPosition(PositionModel.fromEntity(position));
      return payload.data!;
    });
  }

  @override
  Future<Either<Failure, PositionEntity>> updatePosition(
      PositionEntity position) {
    return safeCall(() async {
      final payload = await _remoteDatasource
          .updatePosition(PositionModel.fromEntity(position));
      return payload.data!;
    });
  }
}
