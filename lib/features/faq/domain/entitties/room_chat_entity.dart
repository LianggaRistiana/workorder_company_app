import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/chat_item_entity.dart';

class RoomChatEntity extends Equatable {
  final CompanyEntity companyRoomChat;
  final List<ChatItemEntity> chatItems;

  const RoomChatEntity({
    required this.companyRoomChat,
    required this.chatItems,
  });

  RoomChatEntity copyWith({
    CompanyEntity? companyRoomChat,
    List<ChatItemEntity>? chatItems,
  }) {
    return RoomChatEntity(
      companyRoomChat: companyRoomChat ?? this.companyRoomChat,
      chatItems: chatItems ?? this.chatItems,
    );
  }

  RoomChatEntity addNewChat(ChatItemEntity newChat) {
    return copyWith(
      chatItems: [...chatItems, newChat],
    );
  }

  RoomChatEntity updateChatItem(
    String chatId,
    ChatItemEntity Function(ChatItemEntity old) updater,
  ) {
    final index = chatItems.indexWhere((e) => e.id == chatId);

    if (index == -1) {
      throw Exception("Chat with id $chatId not found");
    }

    final newList = List<ChatItemEntity>.from(chatItems);
    newList[index] = updater(chatItems[index]);

    return copyWith(chatItems: newList);
  }

  @override
  List<Object?> get props => [
        companyRoomChat,
        chatItems,
      ];

  @override
  String toString() {
    return 'RoomChatEntity('
        'company: ${companyRoomChat.id}, '
        'totalChats: ${chatItems.length}, '
        'lastChat: ${chatItems.isNotEmpty ? chatItems.last : 'none'}'
        ')';
  }
}
