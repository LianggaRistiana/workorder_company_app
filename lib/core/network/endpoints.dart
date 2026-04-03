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

  // Forms
  static const String forms = "/forms";

  // Service
  static const String services = "/services";
  static const String servicesToggleActive = "/services/:id/toggle-active";

  // Service Request
  static const String serviceRequestSended = "/service-request/sended";
  static const String serviceRequestInbox = "/service-request/inbox";
  static const String serviceRequestDetail = "/service-request/:id";
  static const String serviceRequestCancel = "/service-request/:id/cancel";
  static const String serviceRequestApprove = "/service-request/:id/approve";
  static const String serviceRequestReject = "/service-request/:id/reject";
  static const String serviceRequestReview = "/service-request/:id/review";
  static const String serviceRequestIntake =
      "/service/:id//service-request/ntake";

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

  // Workorder
  static const String workorder = "/workorders";
  static workorderSetAssignedStaff(String id) =>
      "${workorder.byId(id)}/assign-staffs";
  static workorderSetSubmissions(String id) =>
      "${workorder.byId(id)}/submissions";
  static workorderSetToReady(String id) => "${workorder.byId(id)}/ready";
  static workorderStart(String id) => "${workorder.byId(id)}/start";

  // WorkReport
  static workorderReport(String id) => "${workorder.byId(id)}/report";
  static workorderReportSubmissions(String id) =>
      "${workorder.byId(id)}/report";

  // Public Endpoint
  static const String publicCompanies = '$clientPrefix/companies';
  static const String publicServices = '$clientPrefix/services';
  static const String publicClientServiceRequest =
      '$clientPrefix/client-service-request';

  static publicCompanyServices(String id) =>
      '${publicCompanies.byId(id)}/services';

  // TODO : remove this later
  static publicIntakeForms(String id) =>
      '${publicServices.byId(id)}/intake-forms';
}

extension EndpointIdExtension on String {
  String byId(String id) => "$this/$id";

  String withQuery(Map<String, String> query) {
    final queryString =
        query.entries.map((e) => "${e.key}=${e.value}").join("&");
    return "$this?$queryString";
  }
}
