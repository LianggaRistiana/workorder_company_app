import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/upload_pdf_faq_usecase.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/upload_docs/upload_pdf_doc_state.dart';

class UploadPdfDocCubit extends Cubit<UploadPdfDocState> {
  final UploadPdfFaqUsecase _uploadPdfFaqUsecase;
  StreamSubscription? _sub;

  UploadPdfDocCubit(
    this._uploadPdfFaqUsecase,
  ) : super(const UploadPdfDocState(result: null));

  Future<void> uploadPdf(String filePath) async {
    _sub?.cancel();
    _sub = _uploadPdfFaqUsecase(filePath).listen((data) {
      emit(UploadPdfDocState(result: data));
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
