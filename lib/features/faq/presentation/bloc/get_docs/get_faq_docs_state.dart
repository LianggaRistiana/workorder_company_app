import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';

enum GetFaqDocsStatus { initial, loading, success, error }

class GetFaqDocsState {
  final GetFaqDocsStatus status;
  final List<FaqDocEntity> docs;
  final String? errorMessage;

  const GetFaqDocsState({
    this.status = GetFaqDocsStatus.initial,
    this.docs = const [],
    this.errorMessage,
  });

  GetFaqDocsState copyWith({
    GetFaqDocsStatus? status,
    List<FaqDocEntity>? docs,
    String? errorMessage,
  }) {
    return GetFaqDocsState(
      status: status ?? this.status,
      docs: docs ?? this.docs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
