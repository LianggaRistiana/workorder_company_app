import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/domain/usecase/delete_position_usecase.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/remove/remove_position_state.dart';

class RemovePositionCubit extends Cubit<RemovePositionState> {
  final DeletePositionUsecase deletePositionUsecase;

  RemovePositionCubit({required this.deletePositionUsecase})
      : super(const RemovePositionState());

  Future<void> removePosition(PositionEntity position) async {
    emit(const RemovePositionState(status: RemovePositionStatus.loading));

    final result = await deletePositionUsecase(position);

    result.fold(
      (failure) => emit(
        RemovePositionState(
          status: RemovePositionStatus.error,
          errorMessages: failure.message,
        ),
      ),
      (_) => emit(
        const RemovePositionState(status: RemovePositionStatus.deleted),
      ),
    );
  }
}
