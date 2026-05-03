import 'package:equatable/equatable.dart';

class TextFaqDocDraft extends Equatable {
  final String title;
  final String content;

  const TextFaqDocDraft({
    required this.title,
    required this.content,
  });

  @override
  List<Object?> get props => [
        title,
        content,
      ];
}
