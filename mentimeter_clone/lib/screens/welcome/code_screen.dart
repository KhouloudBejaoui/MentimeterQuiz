import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentimeter_clone/constants.dart';
import 'package:mentimeter_clone/screens/welcome/quiz_manager.dart';
import 'package:mentimeter_clone/screens/welcome/username_screen.dart';
import 'package:websafe_svg/websafe_svg.dart';

class CodeScreen extends StatelessWidget {
  const CodeScreen({Key? key}) : super(key: key);
  static final quizCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebsafeSvg.asset("assets/icons/bg.svg",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 2), //2/6
                  Text(
                    "Let's Play Quiz,",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Text("Enter the code"),
                  const Spacer(), // 1/6
                  TextField(
                    controller: quizCodeController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF1C2341),
                      hintText: "Quiz Code",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  const Spacer(), // 1/6
                  InkWell(
                    onTap: () {
                      final quizCode = quizCodeController.text;
                      QuizManager.setQuizCode(quizCode);
                      Get.to(const UsernameScreen());
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(kDefaultPadding * 0.75),
                      decoration: const BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Text(
                        "Get Started",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
