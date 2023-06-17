import 'package:chatgpt/models/prompts/prompts_map.dart';

class PromptModel {
  final List<PromptItem> data;

  PromptModel({required this.data});

  factory PromptModel.fromMap(Map<String, dynamic> map) {
    return PromptModel(
      data:
          List<PromptItem>.from(map['data']?.map((x) => PromptItem.fromMap(x))),
    );
  }
}
