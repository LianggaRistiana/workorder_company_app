// positions_list_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/positions/domain/usecase/get_positions_usecase.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_event.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_state.dart';

class PositionsListBloc extends Bloc<PositionsListEvent, PositionsListState> {
  final GetPositionsUsecase getPositionsUseCase;

  PositionsListBloc({required this.getPositionsUseCase})
      : super(const PositionsListState()) {
    on<GetPositionsListRequested>(_onGetPositionsRequested);
    // on<NewPositionAdded>(_onNewPositionAdded);
  }

  Future<void> _onGetPositionsRequested(
      GetPositionsListRequested event, Emitter<PositionsListState> emit) async {
    emit(state.copyWith(
      status: PositionsListStatus.loading,
      errorMessage: null,
    ));

    final response =
        await getPositionsUseCase(forceRefresh: event.forceRefresh);

    response.fold(
      (failure) => emit(state.copyWith(
        status: PositionsListStatus.error,
        errorMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        status: PositionsListStatus.loaded,
        positions: data,
      )),
    );
  }

  // Future<void> _onNewPositionAdded(
  //     NewPositionAdded event, Emitter<PositionsListState> emit) async {
  //   emit(state.copyWith(
  //     positions: [event.position, ...state.positions],
  //   ));
  // }
}
