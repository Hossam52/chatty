// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

abstract class BasePromptType {
  final String name;
  String prompt;
  List<PromptQuery> queries;
  BasePromptType(
    this.name,
    this.prompt,
    this.queries,
  );
  String generate();
}

abstract class PromptQuery {
  final String field;
  final int field_type;

  String get userInput;
  String generateQuery(String prompt) {
    //replace template the prompt must be in the format prompt [field] to be replaced by user input
    return prompt
        .toLowerCase()
        .replaceAll('[${field.toLowerCase()}]', userInput);
  }

  PromptQuery.fromJson(Map<String, dynamic> map)
      : field = map['field'] ?? '',
        field_type = map['field_type'] ?? '';
}

class TextPromptType extends PromptQuery {
  final TextEditingController controller = TextEditingController();

  TextPromptType.fromJson(Map<String, dynamic> map) : super.fromJson(map);

  @override
  String get userInput => controller.text;
}

class IntPromptType extends PromptQuery {
  final TextEditingController controller = TextEditingController();
  IntPromptType.fromJson(Map<String, dynamic> map) : super.fromJson(map);

  @override
  String get userInput => controller.text;
}

class ChipsPromptType extends PromptQuery {
  List<String> chips = [];
  ChipsPromptType.fromJson(Map<String, dynamic> map) : super.fromJson(map);

  void insertItem(String item) => chips.add(item);
  void removeItem(int index) =>
      index >= chips.length ? null : chips.removeAt(index);

  @override
  String get userInput {
    String str = chips.join(', ');
    if (chips.length >= 2) {
      str = str.replaceRange(
          str.lastIndexOf(','), str.lastIndexOf(',') + 1, ' and ');
    }
    return str;
  }
}
