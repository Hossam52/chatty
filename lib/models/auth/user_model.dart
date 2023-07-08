import 'dart:convert';

import 'package:chatgpt/models/subscriptions/subscription_model.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int verified;
  final String access_token;
  int remaining_messages;
  final SubscriptionModel? active_subscription;

  bool get isFreeSubscription => active_subscription == null;
  bool get canSendMessage =>
      !isFreeSubscription || (isFreeSubscription && remaining_messages > 0);

  User({
    required this.id,
    required this.verified,
    required this.access_token,
    required this.name,
    required this.phone,
    required this.remaining_messages,
    required this.email,
    required this.active_subscription,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'verified': verified,
      'remaining_messages, ': remaining_messages,
      'access_token': access_token,
      'active_subscription': active_subscription,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['user']['id']?.toInt() ?? 0,
      name: map['user']['name'] ?? '',
      email: map['user']['email'] ?? '',
      phone: map['user']['phone'] ?? '',
      verified: map['user']['verified'] ?? 0,
      remaining_messages: map['user']['remaining_messages'] ?? 0,
      active_subscription: map['user']['active_subscription'] == null
          ? null
          : SubscriptionModel.fromMap(map['user']['active_subscription']),
      access_token: map['access_token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email,phone: $phone,remaining_messages: $remaining_messages, access_token: $access_token)';
  }
}
