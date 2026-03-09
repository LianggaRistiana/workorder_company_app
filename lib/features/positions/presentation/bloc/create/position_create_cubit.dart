import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/domain/usecase/create_position_usecase.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/create/position_create_state.dart';

class PositionCreateCubit extends Cubit<PositionCreateState> {
  final CreatePositionUsecase createPositionUsecase;

  PositionCreateCubit({required this.createPositionUsecase})
      : super(const PositionCreateState());

  Future<void> createPosition(PositionEntity position) async {
    emit(state.copyWith(
        status: PositionCreateStatus.loading, errorMessage: null));

    final result = await createPositionUsecase(position);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PositionCreateStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (createdPosition) => emit(
        state.copyWith(
          status: PositionCreateStatus.success,
          createdPosition: createdPosition,
        ),
      ),
    );
  }
}
