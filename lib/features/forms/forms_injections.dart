import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/data/datasources/forms_remote_datasource.dart';
import 'package:workorder_company_app/features/forms/data/repositories/forms_repository_impl.dart';
import 'package:workorder_company_app/features/forms/domain/repositories/forms_repository.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/create_form_usecase.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/get_form_byid_usecase.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/get_forms_usecase.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/public_get_service_form_usecase.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/create/form_create_cubit.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/detail/form_detail_cubit.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/list/forms_list_bloc.dart';

Future<void> initFormsFeature() async {
  sl.registerLazySingleton<FormsRemoteDatasource>(
      () => FormsRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<FormsRepository>(() => FormsRepositoryImpl(sl()));

  sl.registerLazySingleton<GetFormsUsecase>(() => GetFormsUsecase(sl()));
  sl.registerLazySingleton<GetFormByIdUsecase>(() => GetFormByIdUsecase(sl()));
  sl.registerLazySingleton<CreateFormUsecase>(() => CreateFormUsecase(sl()));
  sl.registerLazySingleton<PublicGetServiceFormUsecase>(() => PublicGetServiceFormUsecase(sl()));

  sl.registerFactory<FormsListBloc>(() => FormsListBloc(getFormsUsecase: sl()));
  sl.registerFactory<FormDetailCubit>(() => FormDetailCubit(getFormByIdUsecase: sl()));
  sl.registerFactory<FormCreateCubit>(() => FormCreateCubit(createFormUsecase: sl()));
  // sl.registerFactory<Forms>(() => FormsBloc(getFormsUsecase: sl(), getFormByIdUsecase: sl(), createFormUsecase: sl()));
}
