import 'dart:convert';

class SubscriptionPlans {
  bool status;
  List<Plan> plans;
  SubscriptionPlans({
    required this.status,
    required this.plans,
  });

  factory SubscriptionPlans.fromMap(Map<String, dynamic> map) {
    return SubscriptionPlans(
      status: map['status'] ?? false,
      plans: List<Plan>.from(map['plans']?.map((x) => Plan.fromMap(x))),
    );
  }
}

class Plan {
  int id;
  String name;
  String storePlanName;
  String price;
  int duration;
  String formattedDuration;
  Plan({
    required this.id,
    required this.name,
    required this.storePlanName,
    required this.price,
    required this.duration,
    required this.formattedDuration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'storePlanName': storePlanName,
      'price': price,
      'duration': duration,
      'formattedDuration': formattedDuration,
    };
  }

  factory Plan.fromMap(Map<String, dynamic> map) {
    return Plan(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      storePlanName: map['store_plan_name'] ?? '',
      price: map['price'] ?? '',
      duration: map['duration']?.toInt() ?? 0,
      formattedDuration: map['formatted_duration'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Plan.fromJson(String source) => Plan.fromMap(json.decode(source));
}
