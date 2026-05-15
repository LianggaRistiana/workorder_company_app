import 'package:workorder_company_app/core/services/network/path_helper.dart';

class Endpoints {
  static const String clientPrefix = "/public";
  static const String authPrefix = "/auth";

  // Auth
  static const String login = "$authPrefix/login";
  static const String profile = "$authPrefix/profile";
  static const String register = "$authPrefix/register";
  static const String logout = "$authPrefix/logout";
  static const String registerCompany = "$authPrefix/register-company";

  // Company
  static const String company = "/company";

  // Employees
  static const String employees = "$company/employees";

  // Positions
  static const String positions = "/positions";

  /// Forms Feature
  /// GET POST PUT DELETE
  static const String forms = "/forms";

  /// Service
  /// GET POST PUT DELETE
  static const String services = "/services";
  static const String servicesToggleActive = "/services/:id/toggle-active";

  // Service Request
  static const String serviceRequestSent = "/service-requests/sent";
  static const String serviceRequestInbox = "/service-requests/inbox";
  static const String serviceRequestDetail = "/service-requests/:id";
  static const String serviceRequestCancel = "/service-requests/:id/cancel";
  static const String serviceRequestApprove = "/service-requests/:id/approve";
  static const String serviceRequestReject = "/service-requests/:id/reject";
  static const String serviceRequestReview = "/service-requests/:id/review";
  static const String serviceRequestCreate = "/service-requests/service/:id";
  static const String serviceRequestIntakePublic =
      "/public/services/:id/intake-form";
  static const String serviceRequestIntakeInternal =
      "/services/:id/intake-form";
  static const String serviceRequestReport = "/service-requests/:id/report";

  // Work Order
  static const String workorders = "/workorders";
  static const String workorderDetail = "/workorders/:id";
  static const String workorderCreate = "/services/:id/create-work-order";
  static const String workorderRecreate = "/workorders/:id/recreate";
  static const String workorderSetSubmissions = "/workorders/:id/submissions";
  static const String workorderSetAssignedStaff =
      "/workorders/:id/assign-staffs";
  static const String workorderSent = "/workorders/:id/sent";
  static const String workorderStart = "/workorders/:id/start";
  static const String workorderApprove = "/workorders/:id/approve";
  static const String workorderReject = "/workorders/:id/reject";
  static const String workorderCancel = "/workorders/:id/cancel";
  static const String workorderComplete = "/workorders/:id/complete";
  static const String workorderFail = "/workorders/:id/fail";

  // Work Report
  static const String workReportDetail = "/workorders/:id/report";
  static const String workReportSetSubmissions = "/workreports/:id/submit";
  static const String workReportSent = "/workreports/:id/sent";
  static const String workReportApprove = "/workreports/:id/approve";
  static const String workReportReject = "/workreports/:id/reject";

  // Memberships
  static const String memberships = "/memberships";
  static const String membershipCodes = "/memberships/codes";
  static const String generateMembershipCode = "/memberships/codes";
  static const String claimMembership = "/memberships/codes/claim";
  static const String deleteMembership = "/memberships/:id";

  // Invitations
  static const String historyInvitations = "/company/invitations/history";
  static const String pendingInvitations = "/invitations/pending";
  static const String inviteEmployees = "/company/invite";
  static const String rejectInvitations = "/invitations/:id/reject";
  static const String acceptInvitations = "/invitations/:id/accept";
  static const String cancelInvitations = "/invitations/:id";

  static const String publicCompanies = '$clientPrefix/companies';
  static const String publicServices = '$clientPrefix/services';
  static publicCompanyServices(String id) =>
      '${publicCompanies.byId(id)}/services';

  // Notifications
  static const String notificationLogs = '/notifications';
  static const String notificationFcmToken = '/notifications/fcm-token';

  // File Upload
  static const String fileUpload = '/files';

  // Template config
  static const String companyType = '/template/company-type';
  static const String serviceTemplates = '/template/company-type/:id/services';
  static const String serviceTemplatePreview = '/template/services/:id';
  static const String generateServices = '/template/services/generate';

  // FAQ
  static const String askQuestion = '/faq/ask';
  static const String faqToggleActive = '/faq/toggle-active';
  static const String faqDocs = '/faq/docs';
  static const String faqTextDocs = '/faq/text-docs';
  static const String faqPDfDocs = '/faq/pdf-docs';
  static const String faqDeleteDocs = '/faq/docs/:id';

  // Dashboard
  static const String serviceRequestStat = '/dashboard/service-request';
  static const String workOrderStat = '/dashboard/work-order';
  static const String companyStat = '/dashboard/company';

  // System Integration
  static const String systemIntegration = 'company/integration-config';
}
