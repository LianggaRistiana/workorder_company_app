import 'package:equatable/equatable.dart';

class PositionEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final bool isActive;

  const PositionEntity({
    required this.id,
    required this.name,
    this.description,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, description, isActive];
}
