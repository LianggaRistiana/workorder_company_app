import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/faq/data/datasources/faq_config_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/data/datasources/faq_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/data/mock/mock_faq_config_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/data/mock/mock_faq_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/data/repositories/faq_config_repository_impl.dart';
import 'package:workorder_company_app/features/faq/data/repositories/faq_repository_impl.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_config_repository.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_repository.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/ask_question_usecase.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/get_faq_docs_usecase.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/get_faq_room_chat_usecase.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/chat/faq_chat_cubit.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/get_docs/get_faq_docs_cubit.dart';

Future<void> initFaqFeature() async {
  sl.registerLazySingleton<FaqRemoteDatasource>(
      () => MockFaqRemoteDatasource());

  sl.registerLazySingleton<FaqConfigRemoteDatasource>(
      () => MockFaqConfigRemoteDatasource());

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

  sl.registerLazySingleton<GetFaqDocsUsecase>(
    () => GetFaqDocsUsecase(
      sl<FaqConfigRepository>(),
    ),
  );

  sl.registerFactory<FaqChatCubit>(
    () => FaqChatCubit(
      sl<GetFaqRoomChatUsecase>(),
      sl<AskQuestionUsecase>(),
    ),
  );

  sl.registerFactory<GetFaqDocsCubit>(
    () => GetFaqDocsCubit(
      sl<GetFaqDocsUsecase>(),
    ),
  );
}
