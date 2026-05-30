import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class FormParams extends Equatable {
  final String? search;
  final List<FormType>? types;

  const FormParams({
    this.search,
    this.types,
  });

  FormParams copyWith({
    Object? search = _sentinel,
    Object? types = _sentinel,
  }) {
    return FormParams(
      search: search == _sentinel ? this.search : search as String,
      types: types == _sentinel ? this.types : types as List<FormType>,
    );
  }

  static const _sentinel = Object();

  int get activeFilterCount {
    int count = 0;
    if (search != null && search!.trim().isNotEmpty) {
      count++;
    }
    if (types != null && types!.isNotEmpty) {
      count++;
    }
    return count;
  }

  @override
  List<Object?> get props => [
        search,
        types,
      ];
}
