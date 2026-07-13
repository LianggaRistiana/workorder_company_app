import 'package:equatable/equatable.dart';

enum ClaimInvitationCodeStatus { initial, previewing, previewed, claiming, claimed, error }

class ClaimInvitationCodeState extends Equatable {
  final ClaimInvitationCodeStatus status;
  final dynamic preview; // InvitationCodePreviewEntity
  final String? errorMessage;

  const ClaimInvitationCodeState({
    this.status = ClaimInvitationCodeStatus.initial,
    this.preview,
    this.errorMessage,
  });

  ClaimInvitationCodeState copyWith({
    ClaimInvitationCodeStatus? status,
    dynamic preview,
    String? errorMessage,
  }) {
    return ClaimInvitationCodeState(
      status: status ?? this.status,
      preview: preview ?? this.preview,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, preview, errorMessage];
}
