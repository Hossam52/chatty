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
  static String getQueryString(List<PromptQuery> queries) {
    // final String queryString = queries
    //     .map((e) => e.generateQuery(String prompt))
    //     .where((element) => element.isNotEmpty)
    //     .join(' and ');
    return 'queryString';
  }

  String generate();
}

abstract class PromptQuery {
  final String name;
  PromptQuery(this.name);

  String generateQuery(String prompt);
}

class TextPromptType extends PromptQuery {
  final TextEditingController controller = TextEditingController();

  TextPromptType(super.name);
  @override
  String generateQuery(String prompt) {
    return prompt.replaceAll('[${name.toLowerCase()}]', controller.text);
  }
}

abstract class IntPromptType implements PromptQuery {
  final TextEditingController controller = TextEditingController();
  @override
  String generateQuery(String prompt) {
    return controller.text.isEmpty ? '' : '$name is ${controller.text}';
  }
}

abstract class ChipsPromptType implements PromptQuery {
  List<String> chips = [];
  @override
  String generateQuery(String prompt) {
    return chips.isEmpty ? '' : '$name is ${'controller.text'}';
  }
}

abstract class DropDownPromptType implements PromptQuery {
  List<String> items = [];
  @override
  String generateQuery(String prompt) {
    return items.isEmpty ? '' : '$name is ${'controller.text'}';
  }
}
