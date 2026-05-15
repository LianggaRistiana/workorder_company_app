import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/data/model/work_reports_filled_form_model.dart';
import 'package:workorder_company_app/features/service_request/data/model/requester_service_request_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

abstract class RequesterServiceRequestRemoteDatasource {
  ApiFutureList<RequesterServiceRequestModel> getServiceRequests();
  ApiFuture<RequesterServiceRequestModel> getServiceRequestDetail(String id);
  ApiFuture<RequesterServiceRequestModel> cancelServiceRequest(String id);
  ApiFuture<FormModel> getIntakeFormForPublic(String serviceId);
  ApiFuture<FormModel> getIntakeFormForInternal(String serviceId);
  ApiFuture<FormModel> getReviewForm(String serviceRequestId);
  ApiFuture<RequesterServiceRequestModel> submitReviewForm(
      String serviceRequestId, SubmissionsModel submission);
  ApiFuture<RequesterServiceRequestModel> submitIntakeForm(
      String serviceId, SubmissionsModel submission);
  ApiFuture<WorkReportsFilledFormModel> getServiceRequestReport(String id);
}

class RequesterServiceRequestRemoteDatasourceImpl
    implements RequesterServiceRequestRemoteDatasource {
  final ApiClient _apiClient;

  RequesterServiceRequestRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFuture<RequesterServiceRequestModel> cancelServiceRequest(
      String id) async {
    final response =
        await _apiClient.patch(Endpoints.serviceRequestCancel.fillId(id));
    return ApiResponse.fromJson(
      response,
      (json) => RequesterServiceRequestModel.fromJson(json),
    );
  }

  @override
  ApiFutureList<RequesterServiceRequestModel> getServiceRequests() async {
    final response = await _apiClient.get(Endpoints.serviceRequestSent);
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => RequesterServiceRequestModel.fromJson(json),
      ),
    );
  }

  @override
  ApiFuture<RequesterServiceRequestModel> getServiceRequestDetail(
      String id) async {
    final response =
        await _apiClient.get(Endpoints.serviceRequestDetail.fillId(id));
    return ApiResponse.fromJson(
        response, (json) => RequesterServiceRequestModel.fromJson(json));
  }

  @override
  ApiFuture<RequesterServiceRequestModel> submitIntakeForm(
      String serviceId, SubmissionsModel submission) {
    return _submitForm(
      Endpoints.serviceRequestCreate.fillId(serviceId),
      submission,
    );
  }

  @override
  ApiFuture<RequesterServiceRequestModel> submitReviewForm(
      String serviceRequestId, SubmissionsModel submission) {
    return _submitForm(
      Endpoints.serviceRequestReview.fillId(serviceRequestId),
      submission,
    );
  }

  @override
  ApiFuture<FormModel> getIntakeFormForPublic(String serviceId) {
    return _getForm(
      Endpoints.serviceRequestIntakePublic.fillId(serviceId),
    );
  }

  @override
  ApiFuture<FormModel> getIntakeFormForInternal(String serviceId) {
    return _getForm(
      Endpoints.serviceRequestIntakeInternal.fillId(serviceId),
    );
  }

  @override
  ApiFuture<FormModel> getReviewForm(String serviceRequestId) {
    return _getForm(
      Endpoints.serviceRequestReview.fillId(serviceRequestId),
    );
  }

  Future<ApiResponse<RequesterServiceRequestModel>> _submitForm(
    String endpoint,
    SubmissionsModel submission,
  ) async {
    final response = await _apiClient.post(
      endpoint,
      data: {"submission": submission.toJson()},
    );

    return ApiResponse.fromJson(
      response,
      (json) => RequesterServiceRequestModel.fromJson(json),
    );
  }

  Future<ApiResponse<FormModel>> _getForm(String endpoint) async {
    final response = await _apiClient.get(endpoint);

    return ApiResponse.fromJson(
      response,
      (json) => FormModel.fromJson(json),
    );
  }

  @override
  ApiFuture<WorkReportsFilledFormModel> getServiceRequestReport(
      String id) async {
    final response =
        await _apiClient.get(Endpoints.serviceRequestReport.fillId(id));
    return ApiResponse.fromJson(
      response,
      (json) => WorkReportsFilledFormModel.fromJson(json),
    );
  }
}
