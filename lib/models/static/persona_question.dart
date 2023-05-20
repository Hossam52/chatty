class PersonaQuestion {
  final String label;
  String? answer;

  PersonaQuestion({required this.label, this.answer});

  String? generateQuestionForChat() {
    if (answer == null || answer!.isEmpty) return null;
    return '$label will be $answer ';
  }
}
