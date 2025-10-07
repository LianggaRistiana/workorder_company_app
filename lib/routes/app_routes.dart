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
  static const ownerServices = '/owner/services';
  static ownerFormDetail(String id) => '/owner/forms/$id';
}
