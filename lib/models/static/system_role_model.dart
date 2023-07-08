import 'persona_question.dart';

abstract class SystemRoleModel {
  final String name;
  final String description;
  final List<PersonaQuestion> questions;

  SystemRoleModel(this.name, this.description, this.questions);

  String generateContent() {
    String prompt = '';
    for (var e in questions) {
      e.generateQuestionForChat() == null
          ? null
          : prompt += '${e.generateQuestionForChat()!} and ';
    }
    // String consideration = '';
    // if (prompt.isNotEmpty) {
    //   prompt = prompt.replaceRange(prompt.lastIndexOf('and'), null, '');
    //   consideration += 'and make consideration for $prompt';
    // }
    // return 'You as a $name act like $description $consideration';
    return 'Want you to act as $name for the following conversation';
  }
}
