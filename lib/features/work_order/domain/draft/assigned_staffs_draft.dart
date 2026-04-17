  import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

class AssignedStaffsDraft {
  UserEntity? staffPic;
  List<UserEntity> assignedStaff;

  AssignedStaffsDraft({
    this.staffPic,
    required this.assignedStaff,
  });

  Map<String, dynamic> toJson() {
    return {
      'staff_pic': staffPic?.email,
      'assigned_staff': assignedStaff.map((staff) => staff.email).toList(),
    };
  }
}
