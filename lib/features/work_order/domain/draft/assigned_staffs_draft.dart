import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

class AssignedStaffsDraft {
  UserEntity? staffPic;
  List<UserEntity> assignedStaffs;

  AssignedStaffsDraft({
    this.staffPic,
    required this.assignedStaffs,
  });

  Map<String, dynamic> toJson() {
    return {
      'staff_pic': staffPic?.email,
      'assign_staffs': assignedStaffs.map((staff) => staff.email).toList(),
    };
  }
}
