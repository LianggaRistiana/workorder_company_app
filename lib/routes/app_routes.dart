
class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const splash = '/splash';

  // Common
  static const profile = '/profile';
  static const forbidden = '/forbidden';

  // Work Order
  static const workorders = '/workorders';
  static const workordersAssignStaff = '/workorders/assign-staff';
  static const workordersSubmission = '/workorders/submissions';
  static const workordersDetail = '/workorders/:id';
  







  // ======= OLD ROUTES ================

  static const ownerPrefix = '/owner';
  static const managerPrefix = '/manager';
  static const staffPrefix = '/staff';
  static const clientPrefix = '/client';

  //Owner Role
  static const ownerHome = '$ownerPrefix/home';
  static const ownerProfile = '$ownerPrefix/profile';
  static const ownerEmployee = '$ownerPrefix/employee';
  static const ownerInviteEmployees = '$ownerPrefix/invite-employee';
  static const ownerCompany = '$ownerPrefix/company';
  static const ownerPositions = '$ownerPrefix/positions';
  static const ownerForms = '$ownerPrefix/forms';
  static const ownerNewForm = '$ownerPrefix/new-forms';
  static ownerFormDetail(String id) => '$ownerPrefix/forms/$id';
  static const ownerServices = '$ownerPrefix/services';
  static const ownerNewService = '$ownerPrefix/new-service';
  static ownerServiceDetail(String id) => '$ownerPrefix/services/$id';

  // Client Role
  static const clientHome = '$clientPrefix/home';
  static const clientProfile = '$clientPrefix/profile';
  static const clientCompanyPortal = '$clientPrefix/companies';
  static const clientServiceRequest = '$clientPrefix/service-request';
  static clientCompanyDetail(String id) => '$clientCompanyPortal/$id';
  static clientServiceRequestDetail(String id) => '$clientServiceRequest/$id';

  static const clientServiceForms = '$clientPrefix/service-forms';
  static clientFillServiceForms(String id) => '$clientServiceForms/$id';
  // static const clientCompanyDetail = '/client/company-detail';

  // Manager Role
  static const managerHome = '$managerPrefix/home';
  static const managerProfile = '$managerPrefix/profile';
  static const managerCsr = '$managerPrefix/service-request';
  static const managerWorkorder = '$managerPrefix/workorders';
  static const managerWorkorderStaffConfig = '$managerPrefix/workorder/staff-config';
  static const managerWorkorderSubmissions = '$managerPrefix/workorder/submissions';
  // static static managerWorkorderSubmissions(String id) => '${managerWorkorder.byId(id)}';

  // Staff Role
  static const staffHome = '$staffPrefix/home';
  static const staffProfile = '$staffPrefix/profile';



  // static workordersDetail(UserRole role) => '/${role.routePrefix}/workorders';
  

}
