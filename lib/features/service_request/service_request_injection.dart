import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/mock/mock_provider_service_request_datasource.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/mock/mock_requester_service_request_datasource.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/provider_service_request_datasource.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/requester_service_request_datasource.dart';
import 'package:workorder_company_app/features/service_request/data/repositories/provider_service_request_repository_impl.dart';
import 'package:workorder_company_app/features/service_request/data/repositories/requester_service_request_repository_impl.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/provider_service_request_repository.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/requester_service_request_repository.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/provider/provider_approve_service_request_usecase.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/provider/provider_get_service_request_detail_usecase.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/provider/provider_get_service_requests_usecase.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/provider/provider_reject_service_request_usecase.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_cancel_service_request_usecase.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_get_intake_form_usecase.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_get_service_request_detail_usecase.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_get_service_requests_usecase.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_submit_intake_form_usecase.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_submit_review_form_usecase.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/action_service_request/provider_action_service_request_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_request_detail/provider_service_request_detail_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_requests_list/provider_service_requests_list_bloc.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/cancel_service_request/requester_cancel_service_request_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/get_intake_form/requester_get_intake_form_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_request_detail/requester_service_request_detail_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_requests_list/requester_service_requests_list_bloc.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/submit_intake_form/requester_submit_intake_form_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/submit_review_form/requester_submit_review_form_cubit.dart';

Future<void> initServiceRequestFeature() async {
  /// Data Source
  sl.registerLazySingleton<RequesterServiceRequestDatasource>(
      // () => RequesterServiceRequestDatasourceImpl(sl()));
      () => MockRequesterServiceRequestDatasource());

  sl.registerLazySingleton<ProviderServiceRequestDatasource>(
      () => MockProviderServiceRequestDatasource());

  /// Repository
  sl.registerLazySingleton<RequesterServiceRequestRepository>(
      () => RequesterServiceRequestRepositoryImpl(sl()));

  sl.registerLazySingleton<ProviderServiceRequestRepository>(
      () => ProviderServiceRequestRepositoryImpl(sl()));

  /// Usecase
  /// [Usecase].Requester
  sl.registerLazySingleton<RequesterGetServiceRequestsUsecase>(
      () => RequesterGetServiceRequestsUsecase(sl()));

  sl.registerLazySingleton<RequesterGetServiceRequestDetailUsecase>(
      () => RequesterGetServiceRequestDetailUsecase(sl()));

  sl.registerLazySingleton<RequesterCancelServiceRequestUsecase>(
      () => RequesterCancelServiceRequestUsecase(sl()));

  sl.registerLazySingleton<RequesterGetIntakeFormUsecase>(
      () => RequesterGetIntakeFormUsecase(sl(), sl()));

  sl.registerLazySingleton<RequesterSubmitIntakeFormUsecase>(
      () => RequesterSubmitIntakeFormUsecase(sl()));

  sl.registerLazySingleton<RequesterSubmitReviewFormUsecase>(
      () => RequesterSubmitReviewFormUsecase(sl()));

  /// [Usecase].Provider
  sl.registerLazySingleton<ProviderGetServiceRequestsUsecase>(
      () => ProviderGetServiceRequestsUsecase(sl()));

  sl.registerLazySingleton<ProviderGetServiceRequestDetailUsecase>(
      () => ProviderGetServiceRequestDetailUsecase(sl()));

  sl.registerLazySingleton<ProviderApproveServiceRequestUsecase>(
      () => ProviderApproveServiceRequestUsecase(sl()));

  sl.registerLazySingleton<ProviderRejectServiceRequestUsecase>(
      () => ProviderRejectServiceRequestUsecase(sl()));

  /// State Management
  /// [State Management].Requester
  sl.registerFactory<RequesterServiceRequestsListBloc>(
      () => RequesterServiceRequestsListBloc(getServiceRequestsUsecase: sl()));

  sl.registerFactory<RequesterServiceRequestDetailCubit>(() =>
      RequesterServiceRequestDetailCubit(getServiceRequestDetailUsecase: sl()));

  sl.registerFactory<RequesterCancelServiceRequestCubit>(() =>
      RequesterCancelServiceRequestCubit(cancelServiceRequestUsecase: sl()));

  sl.registerFactory<RequesterSubmitReviewFormCubit>(
      () => RequesterSubmitReviewFormCubit(submitReviewFormUsecase: sl()));

  sl.registerFactory<RequesterGetIntakeFormCubit>(
      () => RequesterGetIntakeFormCubit(getIntakeFormUsecase: sl()));

  sl.registerFactory<RequesterSubmitIntakeFormCubit>(
      () => RequesterSubmitIntakeFormCubit(submitIntakeFormUsecase: sl()));

  /// [State Management].Provider
  sl.registerFactory<ProviderServiceRequestsListBloc>(
      () => ProviderServiceRequestsListBloc(getServiceRequestsUsecase: sl()));

  sl.registerFactory<ProviderServiceRequestDetailCubit>(() =>
      ProviderServiceRequestDetailCubit(getServiceRequestDetailUsecase: sl()));

  sl.registerFactory<ProviderActionServiceRequestCubit>(() =>
      ProviderActionServiceRequestCubit(
          approveServiceRequestUsecase: sl(),
          rejectServiceRequestUsecase: sl()));
}
