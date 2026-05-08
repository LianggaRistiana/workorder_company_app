import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/detete_faq_docs.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/delete_docs/delete_doc_state.dart';

class DeleteDocCubit extends Cubit<DeleteDocState> {
  final DeleteFaqDocUsecase _deleteFaqUsecase;

  DeleteDocCubit(this._deleteFaqUsecase) : super(DeleteDocState());

  Future<void> deleteDoc(FaqDocEntity doc) async {
    emit(state.copyWith(status: DeleteDocStats.loading));
    final result = await _deleteFaqUsecase.call(doc);
    result.fold(
      (failure) => emit(state.copyWith(
          errorMessage: failure.message, status: DeleteDocStats.error)),
      (result) => emit(state.copyWith(status: DeleteDocStats.success)),
    );
  }
}
