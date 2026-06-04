import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/domain/repositories/positions_repository.dart';

class DeletePositionUsecase {
  final PositionsRepository _repository;

  DeletePositionUsecase(this._repository);

  FutureEither<Empty> call(PositionEntity position) {
    return _repository.deletePosition(position);
  }
}
