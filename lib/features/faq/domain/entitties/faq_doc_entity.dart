import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class FaqDocEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final FaqDocsType type;
  final String? url;
  final DateTime createdAt;

  const FaqDocEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    this.url,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        type,
        url,
        createdAt,
      ];
}
