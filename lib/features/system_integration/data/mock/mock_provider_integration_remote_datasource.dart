import 'package:workorder_company_app/core/model/mock_factory.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/system_integration/data/datasources/provider_integration_remote_datasource.dart';
import 'package:workorder_company_app/features/system_integration/data/mock/integration_data_mock_factory.dart';
import 'package:workorder_company_app/features/system_integration/data/model/provider_integration_data_model.dart';

class MockProviderIntegrationRemoteDatasource
    implements ProviderIntegrationRemoteDatasource {
  ProviderIntegrationDataModel dummyData =
      IntegrationDataMockFactory().createModel();

  @override
  ApiFuture<ProviderIntegrationDataModel> getProviderIntegrationData() async {
    await Future.delayed(Duration(seconds: 2));
    return MockApiResponse.success(dummyData);
  }

  @override
  ApiFuture<ProviderIntegrationDataModel> updateProviderIntegrationData(
      ProviderIntegrationDataModel providerIntegrationData) async {
    await Future.delayed(Duration(seconds: 2));
    dummyData = providerIntegrationData;
    return MockApiResponse.success(dummyData);
  }
}
