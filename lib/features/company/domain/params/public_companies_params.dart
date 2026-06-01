import 'package:equatable/equatable.dart';

class PublicCompaniesParams extends Equatable {
  final String? search;

  const PublicCompaniesParams({
    this.search,
  });

  PublicCompaniesParams copyWith({
    Object? search = _sentinel,
  }) {
    return PublicCompaniesParams(
      search: search == _sentinel ? this.search : search as String?,
    );
  }

  static const _sentinel = Object();

  int get filterCount => search != null ? 1 : 0;

  @override
  List<Object?> get props => [
        search,
      ];
}
