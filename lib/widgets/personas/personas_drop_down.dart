// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:chatgpt/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chatgpt/cubits/personas_cubit/personas_cubit.dart';
import 'package:chatgpt/widgets/personas/persona_questions_dialog.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/constants.dart';

class PersonasDropDown extends StatelessWidget {
  const PersonasDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    final personasCubit = PersonasCubit.instance(context);
    final personas = personasCubit.allSupportedPersonas;
    return FittedBox(
      child: BlocBuilder<PersonasCubit, PersonasState>(
        builder: (context, state) {
          return DropdownButton<String>(
            dropdownColor: scaffoldBackgroundColor,
            iconEnabledColor: Colors.white,
            items: List<DropdownMenuItem<String>>.generate(
                personas.length,
                (index) => DropdownMenuItem(
                    value: personas[index].name,
                    child: TextWidget(
                      label: personas[index].name,
                      fontSize: 15,
                    ))),
            value: personasCubit.selectedPersona.name,
            onChanged: (value) async {
              personasCubit.changeSelected(value!);
              final persona = personas[personasCubit.selectedPersonaIndex];
              bool? savedData = false;
              if (persona.questions.isNotEmpty) {
                savedData = await showDialog<bool>(
                    context: context,
                    builder: (context) => PersonaQuestionsDialog(
                          personaIndex: personasCubit.selectedPersonaIndex,
                        ));
              } else {
                savedData = true;
              }
              if (savedData != null && savedData) {
                ConversationCubit.instance(context)
                    .changeSystemRole(personasCubit.selectedPersona);
              }
              personasCubit.changeSelected(value);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
