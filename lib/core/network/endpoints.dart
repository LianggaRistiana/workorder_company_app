class Endpoints {
  static const String clientPrefix = "/public";
  static const String authPrefix = "/auth";

  // Auth
  static const String login = "$authPrefix/login";
  static const String register = "$authPrefix/register";
  static const String logout = "$authPrefix/logout";
  static const String registerCompany = "$authPrefix/register-company";

  // Company
  static const String company = "/company";

  // Employees
  static const String employees = "$company/employees";
  static const String inviteEmployees = "$company/invite-employees";
  static const String historyInvitations = "$company/invite-history";

  // Positions
  static const String positions = "/positions";

  // Forms
  static const String forms = "/forms";

  // Service
  static const String services = "/services";

  // Public Endpoint
  static const String publicCompanies = '$clientPrefix/companies';
  static const String publicServices = '$clientPrefix/services';
  static const String publicClientServiceRequest = '$clientPrefix/client-service-request';
  static publicCompanyServices(String id) =>
      '${publicCompanies.byId(id)}/services';
  static publicIntakeForms(String id) =>
      '${publicServices.byId(id)}/intake-forms';
  
  // static publicClientServiceRequests(String id) =>
  //     '${publicClientServiceRequest.byId(id)}/intake-forms';
  
}

extension EndpointIdExtension on String {
  String byId(String id) => "$this/$id";

  String withQuery(Map<String, String> query) {
    final queryString =
        query.entries.map((e) => "${e.key}=${e.value}").join("&");
    return "$this?$queryString";
  }
}
