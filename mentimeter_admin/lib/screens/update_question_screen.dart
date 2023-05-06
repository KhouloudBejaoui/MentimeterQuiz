import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mentimeter_admin/models/les_questions.dart';
import 'package:mentimeter_admin/screens/view_questions_list.dart';

class UpdateQuestionScreen extends StatefulWidget {
  final String selectedCode;
  final Question question;

  const UpdateQuestionScreen(this.selectedCode, this.question, {super.key});

  @override
  _UpdateQuestionScreenState createState() => _UpdateQuestionScreenState();
}

class _UpdateQuestionScreenState extends State<UpdateQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionController;
  late List<TextEditingController> _optionControllers;
  late TextEditingController _answerController;
  late int _answer;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question.question);
    _optionControllers = widget.question.options
        .map((option) => TextEditingController(text: option))
        .toList();
    _answerController =
        TextEditingController(text: widget.question.answer.toString());
    _answer = widget.question.answer;
  }

  void _updateQuestion() async {
    final updatedQuestion = Question(
      id: widget.question.id,
      question: _questionController.text,
      options: _optionControllers.map((controller) => controller.text).toList(),
      answer: _answer,
      status: false,
    );
    final response = await http.put(
      Uri.parse(
          'https://mentimeterclone-default-rtdb.firebaseio.com/questions/${widget.selectedCode}/${widget.question.id}.json'),
      body: updatedQuestion.toJson(),
    );

    if (response.statusCode == 200) {
      final result = await Get.to(const ViewQuestionsScreen());
      if (result != null && result is bool && result == true) {
        Get.offAll(const ViewQuestionsScreen());
      }
    } else {
      print('Failed to update question: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(
                  hintText: 'Enter the question',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ..._optionControllers.asMap().entries.map(
                    (entry) => TextFormField(
                      controller: entry.value,
                      decoration: InputDecoration(
                        hintText: 'Enter option ${entry.key + 1}',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an option';
                        }
                        return null;
                      },
                    ),
                  ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _answerController,
                decoration: const InputDecoration(
                  hintText: 'Enter the answer index (0-3)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() {
                  _answer = int.tryParse(value) ?? 0;
                }),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the answer index';
                  }
                  final index = int.tryParse(value);
                  if (index == null || index < 0 || index > 3) {
                    return 'Please enter a valid answer index (0-3)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _updateQuestion();
                    final result = await Get.to(const ViewQuestionsScreen());
                    if (result != null && result is bool && result == true) {
                      Get.offAll(const ViewQuestionsScreen());
                    }
                  }
                },
                child: const Text('Update Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
