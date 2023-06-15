import 'persona_question.dart';
import 'system_role_model.dart';

class ProgrammerPersona extends SystemRoleModel {
  ProgrammerPersona()
      : super('Software egineer', 'experienced developer and a programmer', [
          PersonaQuestion(label: 'Prefered programming language'),
          PersonaQuestion(label: 'Your experience'),
          PersonaQuestion(label: 'Your main expertise'),
          PersonaQuestion(label: 'What your search'),
        ]);
}

class AccountantPerona extends SystemRoleModel {
  AccountantPerona()
      : super('Accountant', 'experienced accountant for the questions', []);
}

class HumanResoursePersona extends SystemRoleModel {
  HumanResoursePersona()
      : super(
            'HR',
            'very talented hr seeking for people in company called Algoriza and want you ask the candidate questions until you are definitely sure for this candidate but question one at a time max 4 questions',
            [
              PersonaQuestion(label: 'Job'),
              PersonaQuestion(label: 'Company description'),
              PersonaQuestion(label: 'Company field'),
              PersonaQuestion(label: 'Expected person age'),
              PersonaQuestion(label: 'Experience needed'),
            ]);
}
