import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/positions/domain/repositories/positions_repository.dart';

class CreatePositionUsecase {
  final PositionsRepository _repository;

  CreatePositionUsecase(this._repository);

  Future<Either<Failure, void>> call(String name) async {
    return _repository.createPostion(name);
  }
}
