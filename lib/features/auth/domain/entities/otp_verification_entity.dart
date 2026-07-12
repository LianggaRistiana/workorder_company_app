import 'package:equatable/equatable.dart';

class OtpVerificationEntity extends Equatable {
  final String email;
  final String otp;

  const OtpVerificationEntity({
    required this.email,
    required this.otp,
  });

  @override
  List<Object?> get props => [email, otp];
}
