import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/start_pairing_data_entity.dart';

class StartPairingDataModel extends StartPairingDataEntity {
  const StartPairingDataModel({required super.redirectUrl});

  factory StartPairingDataModel.fromJson(Map<String, dynamic> json) {
    return StartPairingDataModel(
      redirectUrl: json.field("redirect_url").reqString(),
    );
  }
}
