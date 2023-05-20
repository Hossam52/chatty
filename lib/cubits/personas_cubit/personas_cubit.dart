import 'package:chatgpt/models/static/persona_types.dart';
import 'package:chatgpt/models/static/system_role_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'personas_state.dart';

//Bloc builder and bloc consumer methods
typedef PersonasBlocBuilder = BlocBuilder<PersonasCubit, PersonasState>;
typedef PersonasBlocConsumer = BlocConsumer<PersonasCubit, PersonasState>;

class PersonasCubit extends Cubit<PersonasState> {
  PersonasCubit() : super(PersonasInitial()) {
    allSupportedPersonas = [
      ProgrammerPersona(),
      AccountantPerona(),
      HumanResoursePersona(),
    ];
  }
  static PersonasCubit instance(BuildContext context) =>
      BlocProvider.of<PersonasCubit>(context);

  late List<SystemRoleModel> allSupportedPersonas;

  int selectedPersonaIndex = 1;

  SystemRoleModel get selectedPersona {
    return allSupportedPersonas[selectedPersonaIndex];
  }

  void changeSelected(String value) {
    final index =
        allSupportedPersonas.indexWhere((element) => element.name == value);
    if (index == -1) throw 'Unknown index';
    selectedPersonaIndex = index;
    emit(ChangeSelectedPersona());
  }

  void addAnswerToSelectedPersona(int questionIndex, String? questionAnswer) {
    allSupportedPersonas[selectedPersonaIndex].questions[questionIndex].answer =
        questionAnswer;
  }
}
