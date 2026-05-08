import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/get_faq_docs_usecase.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/get_docs/get_faq_docs_state.dart';

class GetFaqDocsCubit extends Cubit<GetFaqDocsState> {
  final GetFaqDocsUsecase _usecase;

  final Stream<void> _stream;
  late final StreamSubscription<void> _subscription;

  GetFaqDocsCubit(
    this._usecase,
    this._stream,
  ) : super(const GetFaqDocsState()) {
    _subscription = _stream.listen((event) {
      getDocs();
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  Future<void> getDocs({
    bool forceRefresh = false,
  }) async {
    emit(state.copyWith(status: GetFaqDocsStatus.loading));
    final result = await _usecase(forceRefresh: forceRefresh);
    result.fold((failure) {
      emit(state.copyWith(
        status: GetFaqDocsStatus.error,
        errorMessage: failure.message,
      ));
    }, (data) {
      emit(state.copyWith(
        status: GetFaqDocsStatus.success,
        docs: data,
      ));
    });
  }
}
