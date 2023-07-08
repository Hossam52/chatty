import 'dart:convert';

import 'package:chatgpt/models/subscriptions/subscription_plans_model.dart';

class SubscriptionModel {
  final int id;
  final DateTime period_end_date;
  final Plan plan;
  SubscriptionModel({
    required this.id,
    required this.period_end_date,
    required this.plan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'period_end_date': period_end_date.millisecondsSinceEpoch,
      'plan': plan.toMap(),
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id']?.toInt() ?? 0,
      period_end_date:
          DateTime.fromMillisecondsSinceEpoch(map['period_end_date']),
      plan: Plan.fromMap(map['plan']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionModel.fromJson(String source) =>
      SubscriptionModel.fromMap(json.decode(source));
}
