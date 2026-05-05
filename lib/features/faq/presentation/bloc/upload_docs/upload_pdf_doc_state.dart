import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/model/multipart_result.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';

class UploadPdfDocState extends Equatable {
  final MultipartResult<FaqDocEntity>? result;

  const UploadPdfDocState({required this.result});

  bool get isUploading {
    final r = result;
    return r != null && r.progress < 1 && !r.isDone;
  }

  double get progress {
    final r = result;
    return r?.progress ?? 0;
  }

  @override
  List<Object?> get props => [
        isUploading,
        progress,
      ];
}
