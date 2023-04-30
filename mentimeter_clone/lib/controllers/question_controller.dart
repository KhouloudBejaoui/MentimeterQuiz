import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mentimeter_clone/models/les_questions.dart';
import 'package:mentimeter_clone/screens/score/score_screen.dart';

import '../models/db_connect.dart';
// We use get package for our state management

class QuestionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Lets animated our progress bar

  late AnimationController _animationController;
  late Animation _animation;
  // so that we can access our animation outside
  Animation get animation => _animation;

  late PageController _pageController;
  PageController get pageController => _pageController;

  late Future _questions;
  Future get questions => _questions;
  var db = DBconnect();

  Future<List<Question>> getData() async {
    return db.fetchQuestions();
  }

  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  late int _correctAns;
  int get correctAns => _correctAns;

  late int _selectedAns;
  int get selectedAns => _selectedAns;

  // for more about obs please check documentation
  final RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => _questionNumber;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => _numOfCorrectAns;

  // called immediately after the widget is allocated memory
  @override
  void onInit() {
    _questions = getData();
    // Our animation duration is 60 s
    // so our plan is to fill the progress bar within 60s
    _animationController =
        AnimationController(duration: const Duration(seconds: 60), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        // update like setState
        update();
      });

    // start our animation
    // Once 60s is completed go to the next qn
    _animationController.forward().whenComplete(nextQuestion);
    _pageController = PageController();
    super.onInit();
  }

  // // called just before the Controller is deleted from memory
  @override
  void onClose() {
    super.onClose();
    _animationController.dispose();
    _pageController.dispose();
  }

  void checkAns(Question question, int selectedIndex) {
    // because once user press any option then it will run
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) _numOfCorrectAns++;

    // It will stop the counter
    _animationController.stop();
    update();

    // Once user select an ans after 3s it will go to the next qn
    Future.delayed(const Duration(seconds: 3), () {
      nextQuestion();
    });
  }

  Future<void> nextQuestion() async {
    final questions = await _questions;
    final currentQuestionIndex = _questionNumber.value - 1;
    final currentQuestionId = questions[currentQuestionIndex].id;
    final currentQuestionRef = FirebaseDatabase.instance
        .ref()
        .child('questions')
        .child('123')
        .child(currentQuestionId)
        .child('status');

    if (_questionNumber.value != questions.length) {
      final nextQuestionIndex = currentQuestionIndex + 1;
      final nextQuestionId = questions[nextQuestionIndex].id;
      final nextQuestionRef = FirebaseDatabase.instance
          .ref()
          .child('questions')
          .child('123')
          .child(nextQuestionId)
          .child('status');

      StreamSubscription? statusSubscription;
      statusSubscription = currentQuestionRef.onValue.listen((event) {
        final currentQuestionStatus = event.snapshot.value as bool;
        if (currentQuestionStatus) {
          statusSubscription?.cancel();
          nextQuestionRef.onValue.listen((event) {
            final nextQuestionStatus = event.snapshot.value as bool;
            if (nextQuestionStatus) {
              _questionNumber.value++;
              _isAnswered = false;
              _pageController.nextPage(
                duration: const Duration(milliseconds: 250),
                curve: Curves.ease,
              );
              _animationController.reset();
              _animationController.forward().whenComplete(nextQuestion);
            }
          });
        }
      });
    } else {
      Get.to(const ScoreScreen());
    }
  }

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
  }
}
