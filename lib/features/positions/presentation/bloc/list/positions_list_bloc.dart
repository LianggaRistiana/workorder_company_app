// positions_list_bloc.dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/positions/domain/usecase/get_positions_usecase.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_event.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_state.dart';

class PositionsListBloc extends Bloc<PositionsListEvent, PositionsListState> {
  final GetPositionsUsecase getPositionsUseCase;

  final Stream<void> cacheChangedStream;
  late final StreamSubscription _subscription;

  PositionsListBloc(
      {required this.getPositionsUseCase, required this.cacheChangedStream})
      : super(const PositionsListState()) {
    on<GetPositionsListRequested>(_onGetPositionsRequested);
    on<SetFilter>(_onSetFilter);
    
    _subscription = cacheChangedStream.listen((_) {
      add(GetPositionsListRequested(forceRefresh: false));
    });
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

  Future<void> _onSetFilter(
      SetFilter event, Emitter<PositionsListState> emit) async {
    emit(state.copyWith(params: event.params));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
