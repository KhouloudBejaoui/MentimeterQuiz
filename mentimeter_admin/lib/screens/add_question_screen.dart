import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'dashboard_screen.dart';

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _optionsController = TextEditingController();

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

  void _addQuestion() async {
    String questionText = _questionController.text.trim();
    String answerText = _answerController.text.trim();
    List<String> options = _optionsController.text.trim().split(',');

    if (questionText.isNotEmpty &&
        answerText.isNotEmpty &&
        options.isNotEmpty) {
      int answer = int.tryParse(answerText) ?? -1;
      if (answer >= 0 && answer < options.length) {
        Question question = Question(
          id: '',
          question: questionText,
          status: false,
          answer: answer,
          options: options,
        );

        // Update the _firebaseUrl variable using the current value of _selectedCode
        String firebaseUrl =
            'https://mentimeterclone-default-rtdb.firebaseio.com/questions/$_selectedCode.json';

        http.Response response = await http.post(Uri.parse(firebaseUrl),
            body: jsonEncode(question.toJson()));
        if (response.statusCode == 200) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('question added successfully!'),
                actions: [
                  TextButton(
                    onPressed: () => Get.to(const DashboardScreen()),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Handle error
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'An error occurred while adding the question. Please try again later.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Handle invalid answer
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Invalid Answer'),
              content: Text(
                  'Please enter a valid answer index between 0 and ${options.length - 1}.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCode,
                decoration: const InputDecoration(
                  labelText: 'Select a code',
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
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: 'Question Text',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter question text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _answerController,
                decoration: const InputDecoration(
                  labelText: 'Answer Index (0-based)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter answer index';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _optionsController,
                decoration: const InputDecoration(
                  labelText: 'Options (comma-separated)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter options';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addQuestion();
                    //Get.to(const AddQuestionScreen());
                  }
                },
                child: const Text('Add Question'),
              ),
            ],
          ),
        ),
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
