import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/domain/usecase/get_positions_usecase.dart';

part 'positions_event.dart';
part 'positions_state.dart';

class PositionsBloc extends Bloc<PositionsEvent, PositionsState> {
  final GetPositionsUsecase getPositionsUseCase;

  PositionsBloc({required this.getPositionsUseCase})
      : super(PositionsIntial()) {
    on<GetPositionsRequested>(_onGetPositionsRequested);
  }

  Future<void> _onGetPositionsRequested(
      GetPositionsRequested event, Emitter<PositionsState> emit) async {
    emit(PositionsLoading());
    final response = await getPositionsUseCase();

    response.fold((failure) => emit(PositionsError(failure.message)),
        (data) => emit(PositionsLoaded(data)));
  }
}
