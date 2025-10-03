import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/positions/data/datasources/positions_remote_datasource.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/domain/repositories/positions_repository.dart';

class PositionsRepositoryImpl implements PositionsRepository {
  final PositionsRemoteDatasource _remoteDatasource;

  PositionsRepositoryImpl(this._remoteDatasource);
  @override
  Future<Either<Failure, void>> createPostion(String name) {
    // TODO: implement createPostion
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<PositionEntity>>> getPositions() {
    return safeCall(() async {
      final response = await _remoteDatasource.getPositions();
      return response.data ?? [];
    });
  }

  @override
  Future<Either<Failure, void>> updatePosition(String id, String name) {
    // TODO: implement updatePosition
    throw UnimplementedError();
  }
}
