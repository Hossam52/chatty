import 'dart:convert';

import 'package:chatgpt/models/auth/user_model.dart';

class PurchaseSubscriptionModel {
  final bool status;
  final String message;
  final User user;

  PurchaseSubscriptionModel(
      {required this.status, required this.message, required this.user});

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'user': user.toMap(),
    };
  }

  factory PurchaseSubscriptionModel.fromMap(Map<String, dynamic> map) {
    return PurchaseSubscriptionModel(
      status: map['status'] ?? false,
      message: map['message'] ?? '',
      user: User.fromMap(map),
    );
  }

  String toJson() => json.encode(toMap());

  factory PurchaseSubscriptionModel.fromJson(String source) =>
      PurchaseSubscriptionModel.fromMap(json.decode(source));
}
