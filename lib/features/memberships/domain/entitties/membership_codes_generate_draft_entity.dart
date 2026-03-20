import 'package:equatable/equatable.dart';


class MembershipCodesGenerateDraftEntity extends Equatable {
  final int amount;
  final String prefix;

  const MembershipCodesGenerateDraftEntity({
    required this.amount,
    required this.prefix,
  });

  @override
  List<Object?> get props => [
        amount,
        prefix,
      ];
}
