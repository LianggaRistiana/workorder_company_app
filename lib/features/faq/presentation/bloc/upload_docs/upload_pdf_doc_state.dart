import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/model/multipart_result.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';

class UploadPdfDocState extends Equatable {
  final MultipartResult<FaqDocEntity>? result;

  const UploadPdfDocState({
    required this.result,
  });

  bool get isUploading {
    final r = result;
    return r != null && r.progress < 1 && !r.isDone;
  }

  bool get hasError {
    return result?.error != null;
  }

  String? get errorMessage {
    final r = result;
    return r?.error;
  }

  double get progress {
    final r = result;
    return r?.progress ?? 0;
  }

  bool get isDone {
    final r = result;
    return r != null && r.isDone;
  }

  bool get isSuccess {
    final r = result;
    return r != null && r.data != null && r.isDone;
  }

  @override
  List<Object?> get props => [
        hasError,
        isSuccess,
        isUploading,
        progress,
      ];
}
