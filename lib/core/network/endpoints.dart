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
}

extension EndpointIdExtension on String {
  String byId(String id) => "$this/$id";

  String withQuery(Map<String, String> query) {
    final queryString =
        query.entries.map((e) => "${e.key}=${e.value}").join("&");
    return "$this?$queryString";
  }
}
