import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/chat_item_entity.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/ask_question_usecase.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/get_faq_room_chat_usecase.dart';
import 'package:workorder_company_app/features/faq/domain/usecases/retry_ask_usecase.dart';
import 'package:workorder_company_app/features/faq/presentation/bloc/chat/faq_chat_state.dart';

class FaqChatCubit extends Cubit<FaqChatState> {
  final GetFaqRoomChatUsecase _getFaqRoomChatUsecase;
  final AskQuestionUsecase _askQuestionUsecase;
  final RetryAskUsecase _retryAskUsecase;

  FaqChatCubit(
    this._getFaqRoomChatUsecase,
    this._askQuestionUsecase,
    this._retryAskUsecase,
  ) : super(FaqChatState.initial());

  Future<void> init(CompanyEntity company) async {
    final room = await _getFaqRoomChatUsecase(company);
    emit(state.copyWith(roomChat: room));
  }

  Future<void> askQuestion(CompanyEntity company, String query) async {
    if (query.trim().isEmpty) return;

    final tempChatItem = ChatItemEntity.query(query);

    /// 🔹 emit langsung (waiting)
    final currentRoom = state.roomChat;
    if (currentRoom == null) return;

    final optimisticRoom = currentRoom.addNewChat(tempChatItem);
    emit(state.copyWith(roomChat: optimisticRoom));

    /// 🔹 call backend
    final updatedRoom = await _askQuestionUsecase(company, tempChatItem);

    emit(state.copyWith(roomChat: updatedRoom));
  }

  Future<void> retryQuestion(CompanyEntity company, ChatItemEntity chat) async {
    final currentRoom = state.roomChat;
    if (currentRoom == null) return;

    final optimisticRoom =
        currentRoom.updateChatItem(chat.id, (oldChat) => oldChat.retry());
    emit(state.copyWith(roomChat: optimisticRoom));

    /// 🔹 call backend
    final updatedRoom = await _retryAskUsecase(company, chat);

    emit(state.copyWith(roomChat: updatedRoom));
  }
}
