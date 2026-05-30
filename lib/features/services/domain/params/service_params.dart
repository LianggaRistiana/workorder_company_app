import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class ServiceParams extends Equatable {
  final String? search;
  final List<ServiceAccessType>? types;
  final bool? isActive;

  const ServiceParams({
    this.search,
    this.types,
    this.isActive,
  });

  ServiceParams copyWith({
    Object? search = _sentinel,
    Object? types = _sentinel,
    Object? isActive = _sentinel,
  }) {
    return ServiceParams(
      search: search == _sentinel ? this.search : search as String,
      types:
          types == _sentinel ? this.types : types as List<ServiceAccessType>?,
      isActive: isActive == _sentinel ? this.isActive : isActive as bool?,
    );
  }

  static const _sentinel = Object();

  int get activeFilter {
    int count = 0;
    if (isActive != null) {
      count++;
    }

    if (types != null && types!.isNotEmpty) {
      count++;
    }

    if (search != null) {
      count++;
    }

    return count;
  }

  @override
  List<Object?> get props => [
        search,
        types,
        isActive,
      ];
}
