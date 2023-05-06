import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mentimeter_admin/screens/update_question_screen.dart';

import '../models/les_questions.dart';

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

  void _deleteQuestion(String questionId) async {
    final response = await http.delete(Uri.parse(
        'https://mentimeterclone-default-rtdb.firebaseio.com/questions/$_selectedCode/$questionId.json'));

    if (response.statusCode != 200) {
      print('Failed to delete question.');
      return;
    }

    setState(() {
      _questions =
          _questions.where((question) => question.id != questionId).toList();
    });
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
              itemBuilder: (ctx, index) => Card(
                child: ListTile(
                  title: Text(_questions[index].question),
                  subtitle: Text(
                      'Answer: ${_questions[index].options[_questions[index].answer]}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.to(() => UpdateQuestionScreen(
                                _selectedCode,
                                _questions[index],
                              ));
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors
                              .blue, // Change this color to the desired color
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final question = _questions[index];
                          final confirmDelete = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                    'Are you sure you want to delete this question?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (confirmDelete == true) {
                            _deleteQuestion(question.id);
                          }
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
