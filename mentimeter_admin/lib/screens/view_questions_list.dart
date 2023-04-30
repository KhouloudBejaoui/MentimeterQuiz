import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewQuestionsScreen extends StatefulWidget {
  const ViewQuestionsScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewQuestionsScreenState createState() => _ViewQuestionsScreenState();
}

class _ViewQuestionsScreenState extends State<ViewQuestionsScreen> {
  List<Question> _questions = [];
  late String _selectedCode;
  List<String> _codes = [];
  late String _firebaseUrl;

  @override
  void initState() {
    super.initState();
    _getQuestions();
    _codes = ['123', '144']; // Example list of codes
    _selectedCode = _codes[0]; // Set the initial selected code
    _firebaseUrl =
        'https://mentimeterclone-default-rtdb.firebaseio.com/questions/$_selectedCode.json';
  }

  Future<void> _getQuestions() async {
    final response = await http.get(Uri.parse(_firebaseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Question> loadedQuestions = [];

      data.forEach((key, value) {
        loadedQuestions.add(
          Question(
            id: key,
            question: value['question'] as String,
            status: value['status'] as bool,
            answer: value['answer'] as int,
            options: (value['options'] as List<dynamic>)
                .map((e) => e as String)
                .toList(),
          ),
        );
      });

      setState(() {
        _questions = loadedQuestions;
      });
    } else {
      throw Exception('Failed to load questions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: DropdownButtonFormField<String>(
              value: _selectedCode,
              decoration: const InputDecoration(
                labelText: 'Select a quiz code',
                border: OutlineInputBorder(),
              ),
              onChanged: (newValue) {
                setState(() {
                  _selectedCode = newValue!;
                  _firebaseUrl =
                      'https://mentimeterclone-default-rtdb.firebaseio.com/questions/$_selectedCode.json';
                  _getQuestions();
                });
              },
              items: _codes
                  .map((code) => DropdownMenuItem<String>(
                        value: code,
                        child: Text(code),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (ctx, index) => ListTile(
                title: Text(_questions[index].question),
                subtitle: Text(
                    'Answer: ${_questions[index].options[_questions[index].answer]}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Question {
  final String id;
  final int answer;
  final String question;
  final bool status;
  final List<String> options;

  Question({
    required this.id,
    required this.question,
    required this.answer,
    required this.status,
    required this.options,
  });
}
