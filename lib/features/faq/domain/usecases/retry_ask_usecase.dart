import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/chat_item_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/room_chat_entity.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_repository.dart';

class RetryAskUsecase {
  final FaqRepository repository;

  RetryAskUsecase(this.repository);

  Future<RoomChatEntity> call(
    CompanyEntity company,
    ChatItemEntity chatItem,
  ) async {
    return await repository.retry(company, chatItem);
  }
}
