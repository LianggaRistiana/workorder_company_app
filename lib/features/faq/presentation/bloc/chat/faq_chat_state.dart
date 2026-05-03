import 'package:workorder_company_app/features/faq/domain/entitties/room_chat_entity.dart';

class FaqChatState {
  final RoomChatEntity? roomChat;

  const FaqChatState({
    this.roomChat,
  });

  factory FaqChatState.initial() => const FaqChatState();

  FaqChatState copyWith({
    RoomChatEntity? roomChat,
  }) {
    return FaqChatState(
      roomChat: roomChat ?? this.roomChat,
    );
  }
}
