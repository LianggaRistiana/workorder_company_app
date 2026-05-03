import 'package:workorder_company_app/core/utils/safe_parse.dart';

class FaqResponseModel {
  final String answer;

  const FaqResponseModel({
    required this.answer,
  });

  factory FaqResponseModel.fromJson(Map<String, dynamic> json) {
    return FaqResponseModel(
      answer: json.field("asnwer").reqString(),
    );
  }
}
