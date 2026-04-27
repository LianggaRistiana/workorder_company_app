import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/services/cache/list_cache_helper.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/either_helper.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/positions/data/datasources/positions_remote_datasource.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/domain/repositories/positions_repository.dart';

class PositionsRepositoryImpl implements PositionsRepository {
  final PositionsRemoteDatasource _remoteDatasource;

  final ListCacheHelper<PositionEntity> _cache = ListCacheHelper();

  PositionsRepositoryImpl(this._remoteDatasource);

  @override
  @override
  Future<Either<Failure, List<PositionEntity>>> getPositions({
    bool refresh = false,
  }) {
    return _cache.fetchList(
      remoteCall: () async {
        final response = await _remoteDatasource.getPositions();
        return response.data;
      },
      forceRefresh: refresh,
    );
  }

  @override
  Future<Either<Failure, PositionEntity>> createPostion(
      PositionEntity position) async {
    final result = await safeCall(() async {
      final response = await _remoteDatasource
          .createPosition(PositionModel.fromEntity(position));
      return response.data;
    });

    return result.onSuccess((updated) {
      _cache.mergeSingle(
        updated,
        (a, b) => a.id == b.id,
      );
    });
  }

  @override
  Future<Either<Failure, PositionEntity>> updatePosition(
      PositionEntity position) async {
    final result = await safeCall(() async {
      final response = await _remoteDatasource
          .updatePosition(PositionModel.fromEntity(position));
      return response.data;
    });

    return result.onSuccess((updated) {
      _cache.mergeSingle(
        updated,
        (a, b) => a.id == b.id,
      );
    });
  }

  @override
  Future<Either<Failure, PositionEntity>> getPositionById(String id) {
    return safeCall(() async {
      final payload = await _remoteDatasource.getPositionById(id);
      return payload.data;
    });
  }
  
  @override
  void clearCache() {
    _cache.clear();
  }
}
