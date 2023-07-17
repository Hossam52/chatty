import 'dart:convert';

class ConversationTagsModel {
  bool status;
  List<String> tags;
  ConversationTagsModel({
    required this.status,
    required this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'tags': tags,
    };
  }

  factory ConversationTagsModel.fromMap(Map<String, dynamic> map) {
    return ConversationTagsModel(
      status: map['status'] ?? false,
      tags: List<String>.from(map['tags']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationTagsModel.fromJson(String source) =>
      ConversationTagsModel.fromMap(json.decode(source));
}
