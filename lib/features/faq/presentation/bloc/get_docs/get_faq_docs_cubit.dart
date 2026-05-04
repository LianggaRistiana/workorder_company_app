import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/get_faq_docs_usecase.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/get_docs/get_faq_docs_state.dart';

class GetFaqDocsCubit extends Cubit<GetFaqDocsState> {
  final GetFaqDocsUsecase _usecase;

  GetFaqDocsCubit(
    this._usecase,
  ) : super(const GetFaqDocsState());

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
