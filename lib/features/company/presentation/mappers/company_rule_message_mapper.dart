import 'package:workorder_company_app/features/company/domain/policies/company_management_policy.dart';

extension CompanyRulesMessage on CompanyRules {
  String get message {
    switch (this) {
      case CompanyRules.companyMustBeActive:
        return "Perusahaan tidak aktif.";

      case CompanyRules.companyDescMustBeNotNull:
        return "Deskripsi perusahaan belum diisi.";

      case CompanyRules.companyAddressShouldBeNotNull:
        return "Alamat perusahaan belum diisi.";
    }
  }
}