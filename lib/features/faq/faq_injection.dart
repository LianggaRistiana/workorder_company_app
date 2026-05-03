import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/faq/data/datasources/faq_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/data/mock/mock_faq_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/data/repositories/faq_repository_impl.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_repository.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/ask_question_usecase.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/get_faq_room_chat_usecase.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/chat/faq_chat_cubit.dart';

Future<void> initFaqFeature() async {
  sl.registerLazySingleton<FaqRemoteDatasource>(
      () => MockFaqRemoteDatasource());

  sl.registerLazySingleton<FaqRepository>(
    () => FaqRepositoryImpl(
      sl<FaqRemoteDatasource>(),
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

  sl.registerFactory<FaqChatCubit>(
    () => FaqChatCubit(
      sl<GetFaqRoomChatUsecase>(),
      sl<AskQuestionUsecase>(),
    ),
  );
}
