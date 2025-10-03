import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/forms/data/datasources/forms_remote_datasource.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/repositories/forms_repository.dart';

class FormsRepositoryImpl implements FormsRepository {
  final FormsRemoteDatasource _remoteDatasource;

  FormsRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<FormEntity>>> getForms() {
    return safeCall(() async {
      final forms = await _remoteDatasource.getForms();
      return forms.data ?? []; 
    });
  }
}
