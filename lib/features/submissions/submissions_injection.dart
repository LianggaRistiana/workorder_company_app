import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/features/submissions/core/file_upload_manager.dart';
import 'package:workorder_company_app/features/submissions/data/datasources/file_upload_remote_datasource.dart';
import 'package:workorder_company_app/features/submissions/data/repositories/file_upload_repository_impl.dart';
import 'package:workorder_company_app/features/submissions/domain/repositories/file_upload_repository.dart';
import 'package:workorder_company_app/features/submissions/domain/usecases/file_upload_usecase.dart';
import 'package:workorder_company_app/features/submissions/presentation/cubit/file_upload_progress_cubit.dart';

Future<void> initSubmissionsFeature() async {
  sl.registerLazySingleton<FileRemoteDataSource>(() => FileRemoteDataSourceImpl(
        sl<ApiClient>(),
      ));

  sl.registerLazySingleton<FileRepository>(
    () => FileRepositoryImpl(
      sl<FileRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<UploadFileUseCase>(
    () => UploadFileUseCase(
      sl<FileRepository>(),
    ),
  );

  sl.registerSingleton<UploadManager>(UploadManager(
    sl(),
    maxRetry: 3,
  ));

  sl.registerFactory<FileUploadProgressCubit>(
    () => FileUploadProgressCubit(
      sl<UploadManager>(),
    ),
  );
}
