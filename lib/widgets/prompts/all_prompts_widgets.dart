import 'package:chatgpt/models/prompts/prompt_types_interfaces.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';

Widget getPromptQueryWidget(PromptQuery query) {
  if (query is TextPromptType) {
    return TextpromptWidget(textPromptType: query);
  } else if (query is ChipsPromptType) {
    return ChipsPromptWidget(promptType: query);
  } else if (query is IntPromptType) {
    return IntPromptWidget(promptType: query);
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
        name: textPromptType.field,
        child: TextField(
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
          controller: textPromptType.controller,
        ));
  }
}

//-------------------Chips field------------------------------
class ChipsPromptWidget extends StatefulWidget {
  const ChipsPromptWidget({
    super.key,
    required this.promptType,
  });
  final ChipsPromptType promptType;

  @override
  State<ChipsPromptWidget> createState() => _ChipsPromptWidgetState();
}

class _ChipsPromptWidgetState extends State<ChipsPromptWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _BaseClass(
        name: widget.promptType.field,
        child: Column(
          children: [
            if (widget.promptType.chips.isNotEmpty)
              ChipsChoice<int>.single(
                wrapped: false,
                value: null,
                choiceStyle: C2ChipStyle(
                    backgroundColor: ColorManager.accentColor,
                    foregroundColor: ColorManager.white),
                onChanged: (val) {},
                choiceCheckmark: true,
                choiceItems: C2Choice.listFrom<int, String>(
                  source: widget.promptType.chips,
                  delete: (index, item) {
                    return () {
                      setState(() {
                        widget.promptType.removeItem(index);
                      });
                    };
                  },
                  value: (i, v) => i,
                  label: (i, v) => v,
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                    controller: controller,
                  ),
                ),
                GestureDetector(
                  child: Icon(Icons.add, color: ColorManager.accentColor),
                  onTap: () {
                    setState(() {
                      widget.promptType.insertItem(controller.text);
                      controller.clear();
                    });
                  },
                )
              ],
            ),
          ],
        ));
  }
}

//-------------------------------------------------------------
//-------------------int field------------------------------

class IntPromptWidget extends StatelessWidget {
  const IntPromptWidget({
    super.key,
    required this.promptType,
  });
  final IntPromptType promptType;

  @override
  Widget build(BuildContext context) {
    return _BaseClass(
        name: promptType.field,
        child: TextField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
          controller: promptType.controller,
        ));
  }
}
