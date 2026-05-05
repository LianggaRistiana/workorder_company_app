import 'package:equatable/equatable.dart';

class ToggleActiveFaqState extends Equatable {
  final bool isActive;
  final String? errorMessage;

  const ToggleActiveFaqState({
    this.isActive = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        isActive,
        errorMessage,
      ];
}
