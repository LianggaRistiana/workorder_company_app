import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/services/domain/draft/service_draft.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/domain/repositories/services_repository.dart';

class InternalUpdateServiceUsecase {
  final ServicesRepository _repository;

  InternalUpdateServiceUsecase(this._repository);

  FutureEither<ServiceEntity> call(ServiceDraft draft) async {
    try {
      final entity = draft.toEntity();
      return await _repository.updateService(entity);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
          message: e.message ?? "Terjadi Kesalahan", errors: {}));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}