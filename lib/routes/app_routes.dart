class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const registerCompany = '/register-company';
  static const registerAccount = '/register-account';
  static const verifyOtp = '/verify-otp';
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
  static const companyFlowConfig = '/company/flow-config';

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

  // Invitation Codes
  static const invitationCodeList = '/invitation-codes';
  static const claimInvitationCode = '/invitation-codes/claim';

  // Membership
  static const memberships = '/memberships';
  static const membershipsCodes = '/memberships/codes';
  static const uploadMemberCode = '/memberships/codes/upload';
  static const membershipsClaim = '/memberships/claim';

  // Work Order
  static const workOrders = '/workorders';
  static const workOrdersAssignStaff = '/workorders/assign-staff';
  static const workOrdersSubmission = '/workorders/submissions';
  static const workOrdersDetail = '/workorders/:id';

  // // Work Report
  static const workReport = '/workreport';
  static const workReportSubmission = '/workreport/submissions';

  // client side companies
  static const publicCompanies = '/public-companies';
  static const publicCompaniesDetail = '/public-companies/:id';
  static const publicServiceDetail = '/public-companies/service/:id';

  // Notification
  static const notifications = '/notifications';

  // Template Config
  static const templateCompanyType = '/template/company-type';
  static const templateService = '/template/company-type/:id/services';
  static const templateServicePreview = '/template/services/:id/preview';
  static const templateFormPreview = '/template/form/preview';

  // FAQ
  static const chatBot = '/chatbot';
  static const addTextFaqDoc = '/faq/text-docs';
  static const addPdfFaqDoc = '/faq/pdf-docs';
  static const previewPdf = '/preview-pdf';

  // Dashboard
  static const dashboard = '/dashboard';

  // System Integration
  static const pairAccount = '/pair-account/:id';
  static const systemIntegrationConfig = '/company/system-integration';

  // On Boarding Page
  static const onBoarding = '/onboarding';

  static const servicePrice = '/service-price';

  // TODO : Remove this later, route for lab features
  static const String lab = '/lab-feature';
}
