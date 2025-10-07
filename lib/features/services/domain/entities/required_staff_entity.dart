import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class RequiredStaffEntity extends Equatable {
  final PositionEntity position;
  final int minimumStaff;
  final int maximumStaff;

  const RequiredStaffEntity({
    required this.position,
    required this.minimumStaff,
    required this.maximumStaff,
  });

  @override
  List<Object?> get props => [position, minimumStaff, maximumStaff];
}