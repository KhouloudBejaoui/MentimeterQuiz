import 'dart:convert';

import 'package:http/http.dart' as http;
import '../screens/welcome/quiz_manager.dart';
import 'les_questions.dart';

class DBconnect {
  late final String quizCode;
  late final Uri url;

  DBconnect() {
    quizCode = QuizManager.getQuizCode();
    url = Uri.parse(
      "https://mentimeterclone-default-rtdb.firebaseio.com/questions/$quizCode.json",
    );
  }

  Future<List<Question>> fetchQuestions() async {
    return await http.get(url).then((response) {
      var data = json.decode(response.body) as Map<String, dynamic>;
      List<Question> newQuestions = [];
      data.forEach((key, value) {
        var newQuestion = Question(
            id: key,
            question: value['question'],
            status: value['status'],
            options: List.castFrom(value['options']),
            answer: value['answer']);
        newQuestions.add(newQuestion);
      });
      return newQuestions;
    });
  }
}
