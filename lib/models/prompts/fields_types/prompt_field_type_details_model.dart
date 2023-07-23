import 'dart:convert';

class PromptFieldTypeDetailsModel {
  final bool status;
  final List<PromptFieldType> prompt_types;

  PromptFieldTypeDetailsModel(
      {required this.status, required this.prompt_types});

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'prompt_types': prompt_types.map((x) => x.toMap()).toList(),
    };
  }

  factory PromptFieldTypeDetailsModel.fromMap(Map<String, dynamic> map) {
    return PromptFieldTypeDetailsModel(
      status: map['status'] ?? false,
      prompt_types: List<PromptFieldType>.from(
          map['prompt_types']?.map((x) => PromptFieldType.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory PromptFieldTypeDetailsModel.fromJson(String source) =>
      PromptFieldTypeDetailsModel.fromMap(json.decode(source));
}

class PromptFieldType {
  final int id;
  final String description;

  PromptFieldType({required this.id, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
    };
  }

  factory PromptFieldType.fromMap(Map<String, dynamic> map) {
    return PromptFieldType(
      id: map['id']?.toInt() ?? 0,
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PromptFieldType.fromJson(String source) =>
      PromptFieldType.fromMap(json.decode(source));
}
