import 'package:equatable/equatable.dart';

enum ChatState {
  success,
  error,
  waiting,
}

class ChatItemEntity extends Equatable {
  final String id;
  final String userQuery;
  final String? botResponse;
  final ChatState state;
  final DateTime createdAt = DateTime.now();
  final DateTime? responseAt;

  ChatItemEntity({
    required this.id,
    required this.userQuery,
    this.botResponse,
    this.state = ChatState.waiting,
    this.responseAt,
  });

  factory ChatItemEntity.query(String userQuery) {
    return ChatItemEntity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userQuery: userQuery,
    );
  }

  ChatItemEntity success(String response) {
    return ChatItemEntity(
      id: id,
      userQuery: userQuery,
      botResponse: response,
      state: ChatState.success,
      responseAt: DateTime.now(),
    );
  }

  ChatItemEntity error(String response) {
    return ChatItemEntity(
      id: id,
      userQuery: userQuery,
      botResponse: response,
      state: ChatState.error,
      responseAt: DateTime.now(),
    );
  }

  ChatItemEntity retry() {
    return ChatItemEntity(
      id: id,
      userQuery: userQuery,
      botResponse: null,
      state: ChatState.waiting,
      responseAt: null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userQuery,
        botResponse,
        state,
        createdAt,
        responseAt,
      ];
}
