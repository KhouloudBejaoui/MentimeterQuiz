/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentimeter_clone/controllers/question_controller.dart';
import 'package:mentimeter_clone/models/les_questions.dart';

import '../../../constants.dart';
import 'option.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key? key,
    // it means we have to pass this
    required this.question,
    //required this.index,
  }) : super(key: key);

  final Question question;
  //final int index;

  @override
  Widget build(BuildContext context) {
    QuestionController controller = Get.put(QuestionController());
    return FutureBuilder(
        future: controller.questions as Future<List<Question>>,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              var extractedData = snapshot.data as List<Question>;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                padding: const EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Text(
                      extractedData.isNotEmpty
                          ? question.question
                          : 'No questions found',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: kBlackColor),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    ...List.generate(
                      extractedData.isNotEmpty ? question.options.length : 0,
                      (index) => Option(
                        index: index,
                        text: extractedData.isNotEmpty
                            ? question.options[index]
                            : '',
                        press: () => controller.checkAns(
                            extractedData.isNotEmpty
                                ? question
                                : question,
                            index),
                        key: null,
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(
            child: Text('No Data'),
          );
        });
  }
}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentimeter_clone/controllers/question_controller.dart';
import 'package:mentimeter_clone/models/les_questions.dart';

import '../../../constants.dart';
import 'option.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key? key,
    // it means we have to pass this
    required this.question,
  }) : super(key: key);

  final Question question;

  @override
  Widget build(BuildContext context) {
    QuestionController controller = Get.put(QuestionController());
    return FutureBuilder(
        future: controller.questions as Future<List<Question>>,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                padding: const EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Text(
                      question.question,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: kBlackColor),
                    ),
                    const SizedBox(height: kDefaultPadding / 2),
                    ...List.generate(
                      question.options.length,
                      (index) => Option(
                        index: index,
                        text: question.options[index],
                        press: () => controller.checkAns(question, index),
                        key: null,
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(
            child: Text('No Data'),
          );
        });
  }
}
