import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/shared/utils/string_case_utils.dart';

enum InvitationStatus {
  pending,
  accepted,
  rejected,
  cancelled;

  String get displayName {
    switch (this) {
      case InvitationStatus.pending:
        return 'Pending';
      case InvitationStatus.accepted:
        return 'Diterima';
      case InvitationStatus.rejected:
        return 'Ditolak';
      case InvitationStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  String toSnakeCase() {
    return name.toSnakeCase();
  }

  static InvitationStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return InvitationStatus.pending;
      case 'accepted':
        return InvitationStatus.accepted;
      case 'rejected':
        return InvitationStatus.rejected;
      case 'cancelled':
        return InvitationStatus.cancelled;
      default:
        throw ParsingException('Unknown InvitationStatus: $value');
    }
  }
}
