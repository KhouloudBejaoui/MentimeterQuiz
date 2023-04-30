import 'dart:convert';

import 'package:http/http.dart' as http;

import 'les_questions.dart';

class DBconnect {
  final url = Uri.parse(
      "https://mentimeterclone-default-rtdb.firebaseio.com/questions/123.json");

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
