import 'package:workorder_company_app/core/services/cache/cacheable.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/chat_item_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/room_chat_entity.dart';

abstract class FaqRepository implements Cacheable {
  Future<RoomChatEntity> getRoomChat(CompanyEntity company);
  Future<RoomChatEntity> askQuestion(
    CompanyEntity company,
    ChatItemEntity chatItem,
  );
}
