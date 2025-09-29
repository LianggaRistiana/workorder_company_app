import 'package:workorder_company_app/features/auth/data/model/user_model.dart';

class LoginResponseModel {
  final UserModel user;
  final String token;

  LoginResponseModel({
    required this.user,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: UserModel.fromJson(json['user']),
      token: json['token'],
    );
  }
}
