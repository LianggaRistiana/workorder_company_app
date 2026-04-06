import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/mock/mock_requester_service_request_datasource.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/requester_service_request_datasource.dart';
import 'package:workorder_company_app/features/service_request/data/repositories/requester_service_request_repository_impl.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/requester_service_request_repository.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_cancel_service_request_usecase.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_get_intake_form_usecase.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_get_service_request_detail_usecase.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_get_service_requests_usecase.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_submit_review_form_usecase.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/cancel_service_request/requester_cancel_service_request_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/get_intake_form/requester_get_intake_form_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_request_detail/requester_service_request_detail_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_requests_list/requester_service_requests_list_bloc.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/submit_review_form/requester_submit_review_form_cubit.dart';

Future<void> initServiceRequestFeature() async {
  sl.registerLazySingleton<RequesterServiceRequestDatasource>(
      () => MockRequesterServiceRequestDatasource());

  sl.registerLazySingleton<RequesterServiceRequestRepository>(
      () => RequesterServiceRequestRepositoryImpl(sl()));

  sl.registerLazySingleton<RequesterGetServiceRequestsUsecase>(
      () => RequesterGetServiceRequestsUsecase(sl()));

  sl.registerFactory<RequesterGetServiceRequestDetailUsecase>(
      () => RequesterGetServiceRequestDetailUsecase(sl()));

  sl.registerFactory<RequesterCancelServiceRequestUsecase>(
      () => RequesterCancelServiceRequestUsecase(sl()));

  sl.registerFactory<RequesterGetIntakeFormUsecase>(
      () => RequesterGetIntakeFormUsecase(sl(),sl()));

  sl.registerFactory<RequesterSubmitReviewFormUsecase>(
      () => RequesterSubmitReviewFormUsecase(sl()));

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
}
