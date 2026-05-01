import 'package:equatable/equatable.dart';

class ServiceTemplateEntity extends Equatable {
  final String id;
  final String title;
  final String desc;

  const ServiceTemplateEntity({
    required this.id,
    required this.title,
    required this.desc,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        desc,
      ];
}
