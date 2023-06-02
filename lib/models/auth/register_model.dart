import 'dart:convert';
import 'dart:developer';

import 'package:chatgpt/models/auth/user_model.dart';

class RegisterModel {
  final int status;
  final String message;
  final User user;
  RegisterModel({
    required this.status,
    required this.message,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'user': user.toMap(),
    };
  }

  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    return RegisterModel(
      status: map['status']?.toInt() ?? 0,
      message: map['message'] ?? '',
      user: User.fromMap(map),
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterModel.fromJson(String source) =>
      RegisterModel.fromMap(json.decode(source));
}
