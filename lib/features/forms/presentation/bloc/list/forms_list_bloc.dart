import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/params/form_params.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/get_forms_usecase.dart';

part 'forms_list_event.dart';
part 'forms_list_state.dart';

class FormsListBloc extends Bloc<FormsListEvent, FormsListState> {
  final GetFormsUsecase getFormsUsecase;

  final Stream<void> cacheChangedStream;
  late final StreamSubscription _subscription;

  FormsListBloc(
      {required this.getFormsUsecase, required this.cacheChangedStream})
      : super(const FormsListState()) {
    on<GetFormsListRequested>(_onGetFormsListRequested);
    on<SetFormFilter>(_setFilter);

    _subscription = cacheChangedStream.listen((_) {
      add(GetFormsListRequested(forceRefresh: false));
    });
  }

  Future<void> _onGetFormsListRequested(
      GetFormsListRequested event, Emitter<FormsListState> emit) async {
    emit(state.copyWith(status: FormsListStatus.loading, errorMessage: null));

    final result = await getFormsUsecase(
      forceRefresh: event.forceRefresh,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FormsListStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (forms) => emit(
        state.copyWith(
          status: FormsListStatus.loaded,
          forms: forms,
        ),
      ),
    );
  }

  Future<void> _setFilter(
      SetFormFilter event, Emitter<FormsListState> emit) async {
    emit(state.copyWith(filter: event.filter));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
