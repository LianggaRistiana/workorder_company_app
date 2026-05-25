import 'package:equatable/equatable.dart';

class MembershipCodeEntity extends Equatable {
  final String id;
  final String token;
  final String externalCustomerEmail;
  final String externalCustomerName;
  final DateTime? claimedAt;

  const MembershipCodeEntity({
    required this.id,
    required this.token,
    this.claimedAt,
    required this.externalCustomerEmail,
    required this.externalCustomerName,
  });

  @override
  List<Object?> get props => [
        id,
        token,
        claimedAt,
        externalCustomerEmail,
        externalCustomerName,
      ];
}
