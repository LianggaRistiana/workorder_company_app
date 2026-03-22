import 'package:workorder_company_app/core/result/result.dart';

/// Metadata representing warnings produced by business rules.
///
/// Warnings indicate that the operation succeeded,
/// but there are conditions the user should be aware of.
class WarningMeta<E extends Enum> extends ResultMeta {
  final List<E> warnings;

  const WarningMeta(this.warnings);

  bool get hasWarnings => warnings.isNotEmpty;
}