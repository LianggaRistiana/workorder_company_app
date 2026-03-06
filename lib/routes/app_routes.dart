class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const registerCompany = '/register-company';
  static const registerAccount = '/register-account';
  static const home = '/home';
  static const splash = '/splash';

  // Common
  static const profile = '/profile';
  static const forbidden = '/forbidden';

  // Internal Company
  static const company = '/company';
  static const companyUpdate = '/company/update';
  static const companyFaqConfig = '/company/faq-config';
  static const companyManageMenu = '/company/menu';

  // Positions
  static const positions = '/positions';
  static const positionsCreate = '/positions/create';
  static const positionsUpdate = '/positions/update';
  static const positionsDetail = '/positions/:id';

  // Form
  static const forms = '/forms';
  static const formsCreate = '/forms/create';
  static const formsUpdate = '/forms/update';
  static const formsDetail = '/forms/:id';

  // Service
  static const services = '/services';
  static const servicesCreate = '/services/create';
  static const servicesUpdate = '/services/update';
  static const servicesDetail = '/services/:id';

  // Employee
  static const employee = '/employee';
  static const employeeInvite = '/employee/invite';
  static const employeeDetail = '/employee/:id';

  // Work Order
  static const workorders = '/workorders';
  static const workordersAssignStaff = '/workorders/assign-staff/:id';
  static const workordersSubmission = '/workorders/submissions';
  static const workordersDetail = '/workorders/:id';

  // Work Report
  static const workreports = '/workorders/:id/report';
  static const workreportsSubmit = '/workorders/:id/report/submit';

  // internal side client service request
  static const serviceRequest = '/service-request';
  static const serviceRequestDetail = '/service-request/:id';

  // client side  client service request
  static const serviceRequestClientSide = '/client-service-request';
  static const serviceRequestDetailClientSide = '/client-service-request/:id';

  // client side companies
  static const publicCompanies = '/public-companies';
  static const publicCompaniesDetail = '/public-companies/:id';
  static const publicServiceDetail = '/public-companies/service/:id';

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
  static const managerWorkorderStaffConfig =
      '$managerPrefix/workorder/staff-config';
  static const managerWorkorderSubmissions =
      '$managerPrefix/workorder/submissions';
  // static static managerWorkorderSubmissions(String id) => '${managerWorkorder.byId(id)}';

  // Staff Role
  static const staffHome = '$staffPrefix/home';
  static const staffProfile = '$staffPrefix/profile';

  // static workordersDetail(UserRole role) => '/${role.routePrefix}/workorders';
}
