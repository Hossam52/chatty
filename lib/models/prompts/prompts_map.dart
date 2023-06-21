import 'dart:developer';

import 'package:chatgpt/models/prompts/prompt_types_interfaces.dart';

class PromptItem implements BasePromptType {
  PromptItem({required this.queries, required this.name, required this.prompt});

  factory PromptItem.fromMap(Map<String, dynamic> map) {
    log(map.toString());
    return PromptItem(
      queries: List<PromptQuery>.from(map['fields'].map((x) {
        int fieldType = x['field_type'];
        if (fieldType == 1) {
          return TextPromptType.fromJson(x);
        } else if (fieldType == 2) {
          return ChipsPromptType.fromJson(x);
        } else if (fieldType == 3) {
          return IntPromptType.fromJson(x);
        } else {
          return TextPromptType.fromJson(x);
        }
      })),
      name: map['name'],
      prompt: map['prompt'],
    );
  }

  @override
  String generate() {
    String tempPrompt = prompt;
    for (var element in queries) {
      tempPrompt = element.generateQuery(tempPrompt);
    }
    return tempPrompt;
  }

  @override
  List<PromptQuery> queries;

  @override
  String name;

  @override
  String prompt;
}
