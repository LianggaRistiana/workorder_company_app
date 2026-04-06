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
  static const notFound = '/not-found';

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

  // Service Request
  static const serviceRequestInbox = '/service-request/inbox';
  static const serviceRequestSent = '/service-request/sent';
  static const serviceRequestReview = '/service-request/review';
  static const serviceRequestCreate = '/service-request/create';
  static const serviceRequestDetail = '/service-request/:id';

  // Employee
  static const employee = '/employee';
  static const employeeInvite = '/employee/invite';
  static const employeeDetail = '/employee/:id';

  // Invitation
  static const invitationsHistory = '/invitations/history';
  static const invitationsPending = '/invitations/pending';

  // Membership
  static const memberships = '/memberships';
  static const membershipsCodes = '/memberships/codes';
  static const membershipsClaim = '/memberships/claim';

  // Work Order
  // TODO[WO DONE FIRST] : Fix Later
  static const workorders = '/workorders';
  static const workordersAssignStaff = '/workorders/assign-staff/:id';
  static const workordersSubmission = '/workorders/submissions';
  static const workordersDetail = '/workorders/:id';

  // Work Report
  // TODO[WO DONE FIRST] : Fix Later
  static const workreports = '/workorders/:id/report';
  static const workreportsSubmit = '/workorders/:id/report/submit';

  // client side companies
  static const publicCompanies = '/public-companies';
  static const publicCompaniesDetail = '/public-companies/:id';
  static const publicServiceDetail = '/public-companies/service/:id';
}
