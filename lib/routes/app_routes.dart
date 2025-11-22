class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const splash = '/splash';

  //Owner Role
  static const ownerHome = '/owner/home';
  static const ownerProfile = '/owner/profile';
  static const ownerEmployee = '/owner/employee';
  static const ownerInviteEmployees = '/owner/invite-employee';
  static const ownerCompany = '/owner/company';
  static const ownerPositions = '/owner/positions';
  static const ownerForms = '/owner/forms';
  static const ownerNewForm = '/owner/new-forms';
  static ownerFormDetail(String id) => '/owner/forms/$id';
  static const ownerServices = '/owner/services';
  static const ownerNewService = '/owner/new-service';
  static ownerServiceDetail(String id) => '/owner/services/$id';

  // Client Role
  static const clientHome = '/client/home';
  static const clientProfile = '/client/profile';
  static const clientCompanyPortal = '/client/companies';
  static const clientServiceRequest = '/client/service-request';
  static clientCompanyDetail(String id) => '$clientCompanyPortal/$id';
  static clientServiceRequestDetail(String id) => '$clientServiceRequest/$id';

  static const clientServiceForms = '/client/service-forms';
  static clientFillServiceForms(String id) => '$clientServiceForms/$id';
  // static const clientCompanyDetail = '/client/company-detail';


  // Manager Role
  static const managerHome = '/manager/home';
  static const managerProfile = '/manager/profile';
  static const managerCsr = '/manager/service-request';

}
