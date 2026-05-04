import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/text_faq_doc_draft.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/upload_text_faq_usecase.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/upload_docs/upload_text_doc_state.dart';

class UploadTextDocCubit extends Cubit<UploadTextDocState> {
  final UploadTextFaqUsecase _usecase;

  UploadTextDocCubit(this._usecase) : super(UploadTextDocState.initial());

  Future<void> upload(String title, String content) async {
    emit(state.copyWith(status: UploadTextDocStatus.loading));

    final result = await _usecase(
      TextFaqDocDraft(
        title: title,
        content: content,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: UploadTextDocStatus.error,
        message: failure.message,
      )),
      (success) => emit(state.copyWith(
        status: UploadTextDocStatus.success,
      )),
    );
  }
}
