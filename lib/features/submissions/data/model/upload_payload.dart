import 'package:workorder_company_app/core/utils/safe_parse.dart';

class UploadPayload {
  String url;

  UploadPayload({
    required this.url,
  });

  factory UploadPayload.fromMap(Map<String, dynamic> map) {
    return UploadPayload(
      url: map.field('url').reqString(),
    );
  }
}
