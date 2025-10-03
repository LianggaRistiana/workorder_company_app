class Endpoints {
  // Auth
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String logout = "/auth/logout";
  static const String registerCompany = "/auth/register-company";

  // Company
  static const String company = "/company"; // GET
  static const String companies = '/companies'; // PUT, GET

  // Employees
  static const String employees = "/companies/employees"; // GET, PUT
  static const String inviteEmployees = "/companies/invite-employees"; // POST, DEL
  static const String historyInvitations = "/companies/invite-history";// GET

  // Positions
  static const String positions = "/positions"; // GET all, Post, 

  // Forms
  static const String forms = "/forms";
}
