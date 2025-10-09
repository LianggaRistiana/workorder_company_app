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
}
