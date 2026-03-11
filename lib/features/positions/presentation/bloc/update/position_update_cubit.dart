import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/domain/usecase/update_position_usecase.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/update/position_update_state.dart';

class PositionUpdateCubit extends Cubit<PositionUpdateState> {
  final UpdatePositionUsecase updatePositionUsecase;

  PositionUpdateCubit({required this.updatePositionUsecase})
      : super(const PositionUpdateState());

  Future<void> updateEntity(PositionEntity position) async {
    emit(state.copyWith(
        status: PositionUpdateStatus.loading, errorMessage: null));

    final result = await updatePositionUsecase(position);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PositionUpdateStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (createdPosition) => emit(
        state.copyWith(
          status: PositionUpdateStatus.success,
          updatedPosition: createdPosition,
        ),
      ),
    );
  }
}
