import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/domain/meta/position_detail_meta.dart';
import 'package:workorder_company_app/features/positions/domain/usecase/get_position_byid_usecase.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/detail/position_detail_state.dart';

class PositionDetailCubit extends Cubit<PositionDetailState> {
  final GetPositionByidUsecase getPositionByidUsecase;

  PositionDetailCubit({required this.getPositionByidUsecase})
      : super(PositionDetailState());

  Future<void> getPositionById(String id) async {
    emit(state.copyWith(status: PositionDetailStatus.loading));

    final result = await getPositionByidUsecase(id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PositionDetailStatus.error,
          errorMessages: failure.message,
        ),
      ),
      (result) => emit(
        state.copyWith(
          status: PositionDetailStatus.loaded,
          position: result.data,
          meta: result.getMeta<PositionDetailMeta>(),
        ),
      ),
    );
  }

  Future<void> replaceData(PositionEntity newPositions) async {
    emit(state.copyWith(
      status: PositionDetailStatus.loaded,
      position: newPositions,
    ));
  }
}
