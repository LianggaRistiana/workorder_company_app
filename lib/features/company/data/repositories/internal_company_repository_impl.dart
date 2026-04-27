import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/either_helper.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/company/data/datasources/company_management_remote_datasource.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/repositories/internal_company_repository.dart';
import 'package:workorder_company_app/core/services/cache/cached_resource.dart';

class InternalCompanyRepositoryImpl implements InternalCompanyRepository {
  final CompanyManagementRemoteDatasource _companyManagementRemoteDatasource;

  InternalCompanyRepositoryImpl(this._companyManagementRemoteDatasource);

  final CachedResource<CompanyEntity> _cache = CachedResource<CompanyEntity>();

  @override
  Future<Either<Failure, CompanyEntity>> getCompanyInformation({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cache.hasValidValue) {
      final cached = _cache.value;
      if (cached != null) {
        debugPrint("internal company cache hit");
        return Right(cached);
      }
    }

    final result = await safeCall(() async {
      final payload =
          await _companyManagementRemoteDatasource.getCompanyInformation();

      return payload.data;
    });

    return result.onSuccess((data) {
      _cache.update(data);
    });
  }

  @override
  Future<Either<Failure, CompanyEntity>> updateCompanyInformation(
      CompanyEntity companyEntity) async {
    final payload = await safeCall(() async {
      final payload = await _companyManagementRemoteDatasource
          .updateCompanyInformation(CompanyModel.fromEntity(companyEntity));
      return payload.data;
    });
    return payload.onSuccess((data) {
      _cache.update(data);
    });
  }

  @override
  void clearCache() {
    _cache.clear();
  }
}
