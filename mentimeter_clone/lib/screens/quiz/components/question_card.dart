import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentimeter_clone/controllers/question_controller.dart';
import 'package:mentimeter_clone/models/les_questions.dart';

import '../../../constants.dart';
import 'option.dart';

class QuestionCard extends StatefulWidget {
  const QuestionCard({
    Key? key,
    // it means we have to pass this
    required this.question,
  }) : super(key: key);

  final Question question;

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    QuestionController controller = Get.put(QuestionController());
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
            widget.question.question,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: kBlackColor),
          ),
          const SizedBox(height: kDefaultPadding / 2),
          ...List.generate(
            widget.question.options.length,
            (index) => Option(
              index: index,
              text: widget.question.options[index],
              press: () => controller.checkAns(widget.question, index),
              key: null,
            ),
          ),
        ],
      ),
    );
  }
}
