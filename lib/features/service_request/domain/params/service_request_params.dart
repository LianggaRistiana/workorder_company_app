import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class ServiceRequestParams extends Equatable {
  final String? search;
  final List<ServiceRequestStatus>? status;

  const ServiceRequestParams({
    this.search,
    this.status,
  });

  ServiceRequestParams copyWith({
    Object? search = _sentinel,
    Object? status = _sentinel,
  }) {
    return ServiceRequestParams(
      search: search == _sentinel ? this.search : search as String?,
      status: status == _sentinel
          ? this.status
          : status as List<ServiceRequestStatus>?,
    );
  }

  static const _sentinel = Object();

  int get activeFilterCount {
    int count = 0;
    if (search != null && search!.trim().isNotEmpty) {
      count++;
    }
    if (status != null && status!.isNotEmpty) {
      count++;
    }
    return count;
  }

  @override
  List<Object?> get props => [
        search,
        status,
      ];
}
