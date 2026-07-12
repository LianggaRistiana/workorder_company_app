import 'package:equatable/equatable.dart';

class PublicCompaniesParams extends Equatable {
  final String? keyword;

  const PublicCompaniesParams({
    this.keyword,
  });

  PublicCompaniesParams copyWith({
    Object? keyword = _sentinel,
  }) {
    return PublicCompaniesParams(
      keyword: keyword == _sentinel ? this.keyword : keyword as String?,
    );
  }

  static const _sentinel = Object();

  int get filterCount => keyword != null ? 1 : 0;

  @override
  List<Object?> get props => [
        keyword,
      ];
}
