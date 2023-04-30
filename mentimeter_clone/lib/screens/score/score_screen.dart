import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentimeter_clone/constants.dart';
import 'package:mentimeter_clone/controllers/question_controller.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../models/les_questions.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    QuestionController qnController = Get.put(QuestionController());
    return FutureBuilder(
        future: qnController.questions as Future<List<Question>>,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              var extractedData = snapshot.data as List<Question>;
              return Scaffold(
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    WebsafeSvg.asset("assets/icons/bg.svg", fit: BoxFit.fill),
                    Column(
                      children: [
                        const Spacer(flex: 3),
                        Text(
                          "Score",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(color: kSecondaryColor),
                        ),
                        const Spacer(),
                        Text(
                          "${qnController.numOfCorrectAns * 10}/${extractedData.length * 10}",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: kSecondaryColor),
                        ),
                        const Spacer(flex: 3),
                      ],
                    )
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
