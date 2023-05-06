import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentimeter_clone/constants.dart';
import 'package:mentimeter_clone/controllers/question_controller.dart';
import 'package:mentimeter_clone/screens/score/the_result_screen.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../models/les_questions.dart';

class ScoreScreen extends StatefulWidget {
  final String username;

  const ScoreScreen(this.username, {Key? key}) : super(key: key);

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  final databaseUrl = 'https://mentimeterclone-default-rtdb.firebaseio.com';

  @override
  void initState() {
    super.initState();

    FirebaseDatabase.instance
        .ref()
        .child('questions')
        .child('showScore')
        .onValue
        .listen((event) {
      if (event.snapshot.value as bool == true) {
        Get.to(() => const TheResultScreen());
      }
    });
  }

  Future<void> updateScore(String name, int score) async {
    final queryParams = {
      'orderBy': '"name"',
      'equalTo': '"$name"',
      'print': 'pretty',
    };

    final response =
        await http.get(Uri.parse('$databaseUrl/users.json?$queryParams'));

    if (response.statusCode == 200) {
      final decodedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      decodedResponse.forEach((key, value) async {
        if (value['name'] == name) {
          final updateResponse = await http.patch(
              Uri.parse('$databaseUrl/users/$key.json'),
              body: json.encode({'score': score}));
          if (updateResponse.statusCode != 200) {
            throw Exception('Failed to update score');
          }
        }
      });
    } else {
      throw Exception('Failed to retrieve user data');
    }
  }

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
              updateScore(widget.username, qnController.numOfCorrectAns * 10);
              return Scaffold(
                body: Stack(
                  children: [
                    WebsafeSvg.asset("assets/icons/bg.svg",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Your Score is",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(color: kSecondaryColor),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "${qnController.numOfCorrectAns * 10}/${extractedData.length * 10}",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: kSecondaryColor),
                          ),
                        ],
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





/*import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentimeter_clone/constants.dart';
import 'package:mentimeter_clone/controllers/question_controller.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../models/les_questions.dart';

class ScoreScreen extends StatelessWidget {
  final String text;

  const ScoreScreen(this.text, {Key? key}) : super(key: key);

  void saveScoreToDatabase(QuestionController qnController, String userName) {
    final score = qnController.numOfCorrectAns * 10;
    FirebaseDatabase.instance
        .ref()
        .child('users')
        .orderByChild('name')
        .equalTo(userName)
        .once()
        .then((value) {
      FirebaseDatabase.instance.ref().child('users').update({"score": score});
    }).catchError((error) {
      print('Failed to add user: $error');
    });
  }

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
                  children: [
                    WebsafeSvg.asset("assets/icons/bg.svg",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity),
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
*/