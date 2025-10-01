class LogoutResponseModel {
  final bool loggedOut;

  LogoutResponseModel({
    required this.loggedOut,
  });

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) {
    return LogoutResponseModel(
      loggedOut: json['loggedOut'] ?? false,
    );
  }
}
