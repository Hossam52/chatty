import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/cubits/personas_cubit/personas_cubit.dart';
import 'package:chatgpt/models/static/persona_question.dart';
import 'package:chatgpt/models/static/system_role_model.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class PersonaQuestionsDialog extends StatefulWidget {
  const PersonaQuestionsDialog({super.key, required this.personaIndex});
  final int personaIndex;

  @override
  State<PersonaQuestionsDialog> createState() => _PersonaQuestionsDialogState();
}

class _PersonaQuestionsDialogState extends State<PersonaQuestionsDialog> {
  List<TextEditingController> controllers = [];
  late SystemRoleModel persona;
  @override
  void initState() {
    persona = PersonasCubit.instance(context).selectedPersona;
    for (PersonaQuestion question in persona.questions) {
      controllers.add(TextEditingController(text: question.answer));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final questions = persona.questions;
    return Dialog(
      backgroundColor: scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: TextWidget(
                        label: questions[index].label,
                        fontSize: 12,
                        color: Colors.grey,
                      )),
                      Expanded(
                          child: TextField(
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13),
                        controller: controllers[index],
                      ))
                    ],
                  ),
                );
              },
              itemCount: questions.length,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              for (int i = 0; i < persona.questions.length; i++) {
                PersonasCubit.instance(context)
                    .addAnswerToSelectedPersona(i, controllers[i].text);
              }
              Navigator.pop(context, true);
            },
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white)),
            child: const Text('Save and change role'),
          )
        ],
      ),
    );
  }
}
