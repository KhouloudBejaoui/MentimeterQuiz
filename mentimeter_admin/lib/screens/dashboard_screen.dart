import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mentimeter_admin/screens/add_question_screen.dart';
import 'package:get/get.dart';
import 'package:mentimeter_admin/screens/view_questions_list.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Question {
  final String id;
  final int answer;
  final String question;
  final bool status;
  final List<String> options;

  Question({
    required this.id,
    required this.question,
    required this.status,
    required this.answer,
    required this.options,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'status': status,
      'answer': answer,
      'options': options,
    };
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentQuestionNumber = 1;

  bool disableStartButton = false;
  bool disableNextButton = false;
  late String _selectedCode;
  List<String> _codes = [];
  late String firebaseUrl;

  @override
  void initState() {
    super.initState();
    _codes = ['123', '144']; // Example list of codes
    _selectedCode = _codes[0]; // Set the initial selected code
    firebaseUrl =
        'https://mentimeterclone-default-rtdb.firebaseio.com/questions/$_selectedCode.json';
  }

  /*void _startQuiz() async {
    // Update the _firebaseUrl variable using the current value of _selectedCode
    String firebaseUrl =
        'https://mentimeterclone-default-rtdb.firebaseio.com/questions/$_selectedCode.json';
    final response = await http.get(Uri.parse(firebaseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final String questionId = data.keys.first;
        final Map<String, dynamic> questionMap = data[questionId];
        questionMap['status'] = true;

        final updateResponse = await http.put(
            Uri.parse(
                'https://mentimeterclone-default-rtdb.firebaseio.com/questions/$_selectedCode/$questionId.json'),
            body: json.encode(questionMap));

        if (updateResponse.statusCode == 200) {
          setState(() {
            disableStartButton = true;
          });
        } else {
          print('Failed to update question status.');
        }
      }
    } else {
      print('Failed to fetch questions: ${response.statusCode}');
    }
  }*/
  void _startQuiz() async {
    // Update the _firebaseUrl variable using the current value of _selectedCode
    String firebaseUrl = 'https://mentimeterclone-default-rtdb.firebaseio.com/';

    // First update the status of the first question
    final questionResponse =
        await http.get(Uri.parse('$firebaseUrl/questions/$_selectedCode.json'));

    if (questionResponse.statusCode == 200) {
      final Map<String, dynamic> questionData =
          json.decode(questionResponse.body);

      if (questionData.isNotEmpty) {
        final String questionId = questionData.keys.first;
        final Map<String, dynamic> questionMap = questionData[questionId];
        questionMap['status'] = true;

        final updateQuestionResponse = await http.put(
            Uri.parse('$firebaseUrl/questions/$_selectedCode/$questionId.json'),
            body: json.encode(questionMap));

        if (updateQuestionResponse.statusCode != 200) {
          print('Failed to update question status.');
          return;
        }
      }
    } else {
      print('Failed to fetch questions: ${questionResponse.statusCode}');
      return;
    }

    // Then update the active attribute of the quiz
    final quizResponse =
        await http.get(Uri.parse('$firebaseUrl/questions.json'));

    if (quizResponse.statusCode == 200) {
      final Map<String, dynamic> quizData = json.decode(quizResponse.body);

      if (quizData != null) {
        quizData['active'] = true;

        final updateQuizResponse = await http.patch(
            Uri.parse('$firebaseUrl/questions.json'),
            body: json.encode({"active": true}));

        if (updateQuizResponse.statusCode != 200) {
          print('Failed to update quiz active status.');
          return;
        }
      }
    } else {
      print('Failed to fetch quiz: ${quizResponse.statusCode}');
      return;
    }

    setState(() {
      disableStartButton = true;
    });
  }

  void _nextQuestion() async {
    final response = await http.get(Uri.parse(
        'https://mentimeterclone-default-rtdb.firebaseio.com/questions/$_selectedCode.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.isNotEmpty && _currentQuestionNumber < data.length) {
        final String currentQuestionId =
            data.keys.elementAt(_currentQuestionNumber - 1);
        final Map<String, dynamic> currentQuestionMap = data[currentQuestionId];
        currentQuestionMap['status'] = false;

        final String nextQuestionId =
            data.keys.elementAt(_currentQuestionNumber);
        final Map<String, dynamic> nextQuestionMap = data[nextQuestionId];
        nextQuestionMap['status'] = true;

        final currentQuestionResponse = await http.patch(
            Uri.parse(
                'https://mentimeterclone-default-rtdb.firebaseio.com/questions/$_selectedCode/$currentQuestionId.json'),
            body: json.encode({'status': false}));

        final nextQuestionResponse = await http.patch(
            Uri.parse(
                'https://mentimeterclone-default-rtdb.firebaseio.com/questions/$_selectedCode/$nextQuestionId.json'),
            body: json.encode({'status': true}));

        if (currentQuestionResponse.statusCode == 200 &&
            nextQuestionResponse.statusCode == 200) {
          setState(() {
            _currentQuestionNumber++;
            disableNextButton = (_currentQuestionNumber ==
                data.length); // Update disableNextButton
          });
        } else {
          print('Failed to update question statuses.');
        }
      }
    }
  }

  /*void _nextQuestion() async {
    final response = await http.get(Uri.parse(
        'https://mentimeterclone-default-rtdb.firebaseio.com/questions/$_selectedCode.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.isNotEmpty && _currentQuestionNumber < data.length) {
        final String currentQuestionId =
            data.keys.elementAt(_currentQuestionNumber - 1);
        final Map<String, dynamic> currentQuestionMap = data[currentQuestionId];
        currentQuestionMap['status'] = false;

        final String nextQuestionId =
            data.keys.elementAt(_currentQuestionNumber);
        final Map<String, dynamic> nextQuestionMap = data[nextQuestionId];
        nextQuestionMap['status'] = true;

        final currentQuestionResponse = await http.patch(
            Uri.parse(
                'https://mentimeterclone-default-rtdb.firebaseio.com/questions/$_selectedCode/$currentQuestionId.json'),
            body: json.encode({'status': false}));

        final nextQuestionResponse = await http.patch(
            Uri.parse(
                'https://mentimeterclone-default-rtdb.firebaseio.com/questions/$_selectedCode/$nextQuestionId.json'),
            body: json.encode({'status': true}));

        if (currentQuestionResponse.statusCode == 200 &&
            nextQuestionResponse.statusCode == 200) {
          setState(() {
            _currentQuestionNumber++;
          });
          if (_currentQuestionNumber == data.length) {
            // If all questions are done
            setState(() {
              disableNextButton = true; // Disable the button
            });
          }
        } else {
          print('Failed to update question statuses.');
        }
      }
    }
  }*/

  /*void endQuiz() async {
    final response = await http.get(Uri.parse(
        'https://mentimeterclone-default-rtdb.firebaseio.com/questions/$_selectedCode.json'));

    final responseData = json.decode(response.body);

    responseData.forEach((key, value) async {
      final questionResponse = await http.patch(
        Uri.parse(
            'https://mentimeterclone-default-rtdb.firebaseio.com/questions/$_selectedCode.json'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          key: {
            ...value,
            'status': false,
          }
        }),
      );
      print(questionResponse.statusCode);
    });
    setState(() {
      disableStartButton = false;
      disableNextButton = false;
    });
  }*/
  void endQuiz() async {
    const firebaseUrl = 'https://mentimeterclone-default-rtdb.firebaseio.com/';

    // First update the status of all questions
    final response =
        await http.get(Uri.parse('$firebaseUrl/questions/$_selectedCode.json'));
    final responseData = json.decode(response.body);

    responseData.forEach((key, value) async {
      final questionResponse = await http.patch(
        Uri.parse('$firebaseUrl/questions/$_selectedCode.json'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          key: {
            ...value,
            'status': false,
          }
        }),
      );
      print(questionResponse.statusCode);
    });

    // Then update the active attribute of the quiz
    final quizResponse = await http.patch(
      Uri.parse('$firebaseUrl/questions.json'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'active': false,
      }),
    );

    if (quizResponse.statusCode != 200) {
      print('Failed to update quiz active status.');
      return;
    }

    setState(() {
      disableStartButton = false;
      disableNextButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const SizedBox(height: 16.0),
            Card(
              child: InkWell(
                onTap: () => Get.to(const AddQuestionScreen()),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Add New Question',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Click here to add a new question to the database.',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              child: InkWell(
                onTap: () => Get.to(const ViewQuestionsScreen()),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'View Questions List',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Click here to view the list of questions in the database.',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Let's Start A Quiz",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedCode,
              decoration: const InputDecoration(
                labelText: 'Select a quiz code',
                border: OutlineInputBorder(),
              ),
              onChanged: (newValue) {
                setState(() {
                  _selectedCode = newValue!;
                });
              },
              items: _codes
                  .map((code) => DropdownMenuItem<String>(
                        value: code,
                        child: Text(code),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: disableStartButton ? null : _startQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Set the background color
                  ),
                  child: const Text('Start Quiz'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: disableNextButton ? null : _nextQuestion,
                  child: const Text('Next Question'),
                ),
                const SizedBox(height: 100.0),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement functionality for this button
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Set the background color
                  ),
                  child: const Text('Show Score'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: endQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Set the background color
                  ),
                  child: const Text('End Quiz'),
                ),
              ],
            ),
          ])),
    );
  }
}
