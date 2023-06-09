class Question {
  final String id;
  final int answer;
  final String question;
  final bool status;
  final List<String> options;

  Question(
      {required this.id,
      required this.question,
      required this.status,
      required this.answer,
      required this.options});

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'status': status,
      'answer': answer,
      'options': options,
    };
  }
}
