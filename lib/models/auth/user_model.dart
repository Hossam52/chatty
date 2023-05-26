import 'dart:convert';

class User {
  final int id;
  final String name;
  final String email;
  final String access_token;

  User(
      {required this.id,
      required this.access_token,
      required this.name,
      required this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'access_token': access_token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['user']['id']?.toInt() ?? 0,
      name: map['user']['name'] ?? '',
      email: map['user']['email'] ?? '',
      access_token: map['access_token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, access_token: $access_token)';
  }
}
