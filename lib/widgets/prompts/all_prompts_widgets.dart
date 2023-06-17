import 'package:chatgpt/models/prompts/prompt_types_interfaces.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';

Widget getPromptQueryWidget(PromptQuery query) {
  if (query is TextPromptType) {
    return TextpromptWidget(textPromptType: query);
  } else {
    throw Exception('Unhandled exception');
  }
}

class _BaseClass extends StatelessWidget {
  const _BaseClass({super.key, required this.name, required this.child});
  final String name;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 2,
              child: TextWidget(
                label: name,
                fontSize: 12,
                color: Colors.grey,
              )),
          Expanded(flex: 3, child: child)
        ],
      ),
    );
  }
}

class TextpromptWidget extends StatelessWidget {
  const TextpromptWidget({
    super.key,
    required this.textPromptType,
  });
  final TextPromptType textPromptType;

  @override
  Widget build(BuildContext context) {
    return _BaseClass(
        name: textPromptType.name,
        child: TextField(
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
          controller: textPromptType.controller,
        ));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 2,
              child: TextWidget(
                label: textPromptType.name,
                fontSize: 12,
                color: Colors.grey,
              )),
          Expanded(
              flex: 3,
              child: TextField(
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
                controller: textPromptType.controller,
              ))
        ],
      ),
    );
  }
}
