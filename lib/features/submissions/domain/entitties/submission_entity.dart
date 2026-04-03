import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/field_data_entity.dart';

class SubmissionEntity {
  final String id;
  final String formId;
  final FormType submissionType;
  final SubmissionStatus? status;
  final UserEntity? submittedBy;
  final List<FieldDataEntity>? fieldsData;
  final DateTime? createdAt;

  const SubmissionEntity({
    required this.id,
    required this.formId,
    required this.submissionType,
    this.status,
    this.submittedBy,
    this.fieldsData,
    this.createdAt,
  });

  SubmissionEntity copyWith({
    String? id,
    String? formId,
    FormType? submissionType,
    SubmissionStatus? status,
    UserEntity? submittedBy,
    List<FieldDataEntity>? fieldsData,
    DateTime? createdAt,
  }) {
    return SubmissionEntity(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      submissionType: submissionType ?? this.submissionType,
      status: status ?? this.status,
      submittedBy: submittedBy ?? this.submittedBy,
      fieldsData: fieldsData ?? this.fieldsData,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'SubmissionEntity(id: $id, formId: $formId, submissionType: $submissionType, status: $status, submittedBy: $submittedBy, fieldsData: ${fieldsData?.map((e) => e.toString()).toList() ?? []})';
  }
}

extension SubmissionEntityTools on SubmissionEntity {
  /// Apakah submission sudah punya field data
  bool get hasFields => fieldsData != null && fieldsData!.isNotEmpty;

  /// Ambil semua field (non-null & immutable)
  List<FieldDataEntity> get safeFields => List.unmodifiable(fieldsData ?? []);

  /// Ambil field berdasarkan order
  FieldDataEntity? getFieldByOrder(String order) {
    try {
      return safeFields.firstWhere((e) => e.order == order);
    } catch (_) {
      return null;
    }
  }

  /// Ambil value berdasarkan order
  dynamic getValue(String order) {
    return getFieldByOrder(order)?.value;
  }

  /// Hapus field berdasarkan order
  SubmissionEntity removeField(String order) {
    final updated = safeFields.where((e) => e.order != order).toList();

    return copyWith(fieldsData: updated);
  }

  /// Urutkan field berdasarkan order (ascending)
  List<FieldDataEntity> get sortedFields {
    final list = [...safeFields];
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  /// Apakah submission sudah dibuat
  bool get isCreated => createdAt != null;

  /// Apakah submission sudah memiliki status
  bool get hasStatus => status != null;
}
