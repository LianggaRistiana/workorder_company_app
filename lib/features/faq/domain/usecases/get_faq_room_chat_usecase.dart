import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/room_chat_entity.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_repository.dart';

class GetFaqRoomChatUsecase {
  final FaqRepository repository;

  GetFaqRoomChatUsecase(this.repository);

  Future<RoomChatEntity> call(CompanyEntity company) async {
    return await repository.getRoomChat(company);
  }
}
