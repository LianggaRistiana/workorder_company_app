import 'package:equatable/equatable.dart';

class MembershipCodesGenerateDraftEntity extends Equatable {
  final int amount;
  final String preffix;

  const MembershipCodesGenerateDraftEntity({
    required this.amount,
    required this.preffix,
  });

  @override
  List<Object?> get props => [
        amount,
        preffix,
      ];
}
