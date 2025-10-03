import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/data/datasources/forms_remote_datasource.dart';
import 'package:workorder_company_app/features/forms/data/repositories/forms_repository_impl.dart';
import 'package:workorder_company_app/features/forms/domain/repositories/forms_repository.dart';
import 'package:workorder_company_app/features/forms/domain/usecases/get_forms_usecase.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/forms_bloc.dart';

Future<void> initFormsFeature() async {
  sl.registerLazySingleton<FormsRemoteDatasource>(
      () => FormsRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<FormsRepository>(() => FormsRepositoryImpl(sl()));

  sl.registerLazySingleton<GetFormsUsecase>(() => GetFormsUsecase(sl()));

  sl.registerFactory<FormsBloc>(() => FormsBloc(getFormsUsecase: sl()));
}
