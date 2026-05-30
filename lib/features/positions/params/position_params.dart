import 'package:equatable/equatable.dart';

class PositionParams extends Equatable {
  final String? search;

  const PositionParams({this.search});

  PositionParams copyWith({
    Object? search = _sentinel,
  }) {
    return PositionParams(
      search: search == _sentinel ? this.search : search as String?,
    );
  }

  static const _sentinel = Object();

  @override
  List<Object?> get props => [
        search,
      ];
}
