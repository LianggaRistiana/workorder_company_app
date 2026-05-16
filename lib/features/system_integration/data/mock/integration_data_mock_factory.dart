import 'package:faker/faker.dart';
import 'package:workorder_company_app/core/model/mock_factory.dart';
import 'package:workorder_company_app/features/system_integration/data/model/provider_integration_data_model.dart';

class IntegrationDataMockFactory
    extends MockFactory<ProviderIntegrationDataModel> {
  @override
  Map<String, dynamic> createJson() {
    return {
      "external_login_url": faker.internet.httpsUrl(),
      "external_verify_url": faker.internet.httpsUrl(),
      "external_check_status_memberships_url": faker.internet.httpsUrl(),
      "secret_key": faker.guid.guid(),
      "is_integration_active": faker.randomGenerator.boolean(),
    };
  }

  @override
  List<ProviderIntegrationDataModel> createList({int count = 10}) {
    return List.generate(
      count,
      (index) => ProviderIntegrationDataModel.fromJson(createJson()),
    );
  }

  @override
  createModel() {
    return ProviderIntegrationDataModel.fromJson(createJson());
  }
}
