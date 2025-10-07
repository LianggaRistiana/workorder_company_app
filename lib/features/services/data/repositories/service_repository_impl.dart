import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/services/data/datasources/service_remote_datasource.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDatasource _remoteDatasource;

  ServiceRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<ServiceEntity>>> getService(String id) {
    // TODO: implement getService
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getServices() {
    return safeCall(() async {
      final services = await _remoteDatasource.getServices();
      return services.data ?? [];
    });
  }
}
