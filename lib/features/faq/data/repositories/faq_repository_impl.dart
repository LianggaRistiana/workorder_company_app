import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/faq/data/datasources/faq_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/chat_item_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/room_chat_entity.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_repository.dart';

class FaqRepositoryImpl implements FaqRepository {
  final FaqRemoteDatasource _remoteDatasource;

  final List<RoomChatEntity> _cache = [];

  FaqRepositoryImpl(this._remoteDatasource);

  @override
  Future<RoomChatEntity> askQuestion(
    CompanyEntity company,
    ChatItemEntity chatItem,
  ) async {
    var room = _getOrAddRoomChat(company);

    room = room.addNewChat(chatItem);
    _replaceRoom(room);

    final result = await safeCall(() async =>
        _remoteDatasource.askQuestion(company.id, chatItem.userQuery));

    result.fold(
      (error) {
        room = room.updateChatItem(
          chatItem.id,
          (chat) => chat.error(error.message),
        );
      },
      (response) {
        room = room.updateChatItem(
          chatItem.id,
          (chat) => chat.success(response.data.answer),
        );
      },
    );

    _replaceRoom(room);

    appLogger.i(room);

    return room;
  }

  @override
  Future<RoomChatEntity> getRoomChat(CompanyEntity company) async {
    return _getOrAddRoomChat(company);
  }

  @override
  void clearCache() {
    _cache.clear();
  }

  // =============================
  //  INTERNAL HELPERS
  // =============================

  RoomChatEntity _getOrAddRoomChat(CompanyEntity company) {
    final index = _cache.indexWhere((r) => r.companyRoomChat.id == company.id);

    if (index != -1) {
      return _cache[index];
    }

    final newRoom = RoomChatEntity(
      companyRoomChat: company,
      chatItems: [],
    );

    _cache.add(newRoom);
    return newRoom;
  }

  void _replaceRoom(RoomChatEntity updatedRoom) {
    final index = _cache.indexWhere(
        (r) => r.companyRoomChat.id == updatedRoom.companyRoomChat.id);

    if (index == -1) {
      _cache.add(updatedRoom);
      return;
    }

    _cache[index] = updatedRoom;
  }

  @override
  Future<RoomChatEntity> retry(
      CompanyEntity company, ChatItemEntity chatItem) async {
    var room = _getOrAddRoomChat(company);
    room = room.updateChatItem(
      chatItem.id,
      (chat) => chat.retry(),
    );
    _replaceRoom(room);

    final result = await safeCall(() async =>
        _remoteDatasource.askQuestion(company.id, chatItem.userQuery));

    result.fold(
      (error) {
        room = room.updateChatItem(
          chatItem.id,
          (chat) => chat.error(error.message),
        );
      },
      (response) {
        room = room.updateChatItem(
          chatItem.id,
          (chat) => chat.success(response.data.answer),
        );
      },
    );

    _replaceRoom(room);

    appLogger.i(room);

    return room;
  }
}
