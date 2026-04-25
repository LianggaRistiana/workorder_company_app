import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/field_data_entity.dart';

class SubmissionEntity {
  final String id;
  final String formId;
  final FormType submissionType;
  final List<FieldDataEntity>? fieldsData;
  final DateTime createdAt;

  const SubmissionEntity({
    required this.id,
    required this.formId,
    required this.submissionType,
    this.fieldsData,
    required this.createdAt,
  });

  SubmissionEntity copyWith({
    String? id,
    String? formId,
    FormType? submissionType,
    UserEntity? submittedBy,
    List<FieldDataEntity>? fieldsData,
    DateTime? createdAt,
  }) {
    return SubmissionEntity(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      submissionType: submissionType ?? this.submissionType,
      fieldsData: fieldsData ?? this.fieldsData,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

extension SubmissionEntityTools on SubmissionEntity {
  bool get hasFields => fieldsData != null && fieldsData!.isNotEmpty;

  List<FieldDataEntity> get safeFields => List.unmodifiable(fieldsData ?? []);

  FieldDataEntity? getFieldByOrder(String order) {
    try {
      return safeFields.firstWhere((e) => e.order == order);
    } catch (_) {
      return null;
    }
  }

  dynamic getValue(String order) {
    return getFieldByOrder(order)?.value;
  }

  SubmissionEntity removeField(String order) {
    final updated = safeFields.where((e) => e.order != order).toList();

    return copyWith(fieldsData: updated);
  }

  List<FieldDataEntity> get sortedFields {
    final list = [...safeFields];
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }
}
