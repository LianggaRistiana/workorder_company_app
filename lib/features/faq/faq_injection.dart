import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/features/faq/data/datasources/faq_config_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/data/datasources/faq_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/data/repositories/faq_config_repository_impl.dart';
import 'package:workorder_company_app/features/faq/data/repositories/faq_repository_impl.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_config_repository.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_repository.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/ask_question_usecase.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/detete_faq_docs.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/get_faq_docs_usecase.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/get_faq_room_chat_usecase.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/retry_ask_usecase.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/toggle_active_faq_usecase.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/upload_pdf_faq_usecase.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/upload_text_faq_usecase.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/chat/faq_chat_cubit.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/delete_docs/delete_doc_cubit.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/get_docs/get_faq_docs_cubit.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/toggle_active/toggle_active_faq_cubit.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/upload_docs/upload_pdf_doc_cubit.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/upload_docs/upload_text_doc_cubit.dart';

Future<void> initFaqFeature() async {
  sl.registerLazySingleton<FaqRemoteDatasource>(
    () => FaqRemoteDatasourceImpl(
      sl<ApiClient>(),
    ),
  );

  sl.registerLazySingleton<FaqConfigRemoteDatasource>(
    () => FaqConfigRemoteDatasourceImpl(
      sl<ApiClient>(),
    ),
  );

  sl.registerLazySingleton<FaqRepository>(
    () => FaqRepositoryImpl(
      sl<FaqRemoteDatasource>(),
    ),
  );

  sl.registerLazySingleton<FaqConfigRepository>(
    () => FaqConfigRepositoryImpl(
      sl<FaqConfigRemoteDatasource>(),
    ),
  );

  sl.registerLazySingleton<GetFaqRoomChatUsecase>(
    () => GetFaqRoomChatUsecase(
      sl<FaqRepository>(),
    ),
  );

  sl.registerLazySingleton<AskQuestionUsecase>(
    () => AskQuestionUsecase(
      sl<FaqRepository>(),
    ),
  );

  sl.registerLazySingleton<RetryAskUsecase>(
    () => RetryAskUsecase(
      sl<FaqRepository>(),
    ),
  );

  sl.registerLazySingleton<GetFaqDocsUsecase>(
    () => GetFaqDocsUsecase(
      sl<FaqConfigRepository>(),
    ),
  );

  sl.registerLazySingleton<UploadTextFaqUsecase>(
    () => UploadTextFaqUsecase(
      sl<FaqConfigRepository>(),
    ),
  );

  sl.registerLazySingleton<UploadPdfFaqUsecase>(
    () => UploadPdfFaqUsecase(
      sl<FaqConfigRepository>(),
    ),
  );

  sl.registerLazySingleton<ToggleActiveFaqUsecase>(
    () => ToggleActiveFaqUsecase(
      sl<FaqConfigRepository>(),
    ),
  );

  sl.registerLazySingleton<DeleteFaqDocUsecase>(
    () => DeleteFaqDocUsecase(
      sl<FaqConfigRepository>(),
    ),
  );

  sl.registerFactory<FaqChatCubit>(
    () => FaqChatCubit(
      sl<GetFaqRoomChatUsecase>(),
      sl<AskQuestionUsecase>(),
      sl<RetryAskUsecase>(),
    ),
  );

  sl.registerFactory<GetFaqDocsCubit>(
    () => GetFaqDocsCubit(
      sl<GetFaqDocsUsecase>(),
      sl<FaqConfigRepository>().cacheChanged,
    ),
  );

  sl.registerFactory<UploadTextDocCubit>(
    () => UploadTextDocCubit(
      sl<UploadTextFaqUsecase>(),
    ),
  );

  sl.registerFactory<UploadPdfDocCubit>(
    () => UploadPdfDocCubit(
      sl<UploadPdfFaqUsecase>(),
    ),
  );

  sl.registerFactory<ToggleActiveFaqCubit>(
    () => ToggleActiveFaqCubit(
      sl<ToggleActiveFaqUsecase>(),
    ),
  );

  sl.registerFactory<DeleteDocCubit>(
    () => DeleteDocCubit(
      sl<DeleteFaqDocUsecase>(),
    ),
  );
}
