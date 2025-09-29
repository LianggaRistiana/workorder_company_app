import 'package:equatable/equatable.dart';

class PositionEntity extends Equatable {
  final String id;
  final String name;

  const PositionEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
