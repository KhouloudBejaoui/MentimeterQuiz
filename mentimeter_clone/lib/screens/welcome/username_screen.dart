import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentimeter_clone/constants.dart';
import 'package:mentimeter_clone/screens/quiz/quiz_screen.dart';
import 'package:mentimeter_clone/screens/welcome/quiz_manager.dart';
import 'package:websafe_svg/websafe_svg.dart';

final databaseReference = FirebaseDatabase.instance.ref();

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  void addUser(String name) {
    databaseReference
        .child("users")
        .push()
        .set({'name': name, 'score': 0}).then((value) {
      print('User added successfully');
    }).catchError((error) {
      print('Failed to add user: $error');
    });
  }

  static final _nameController = TextEditingController();

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
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Text("Enter your informations below"),
                  const Spacer(), // 1/6
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 72, 67, 67),
                      hintText: "Full Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  const Spacer(), // 1/6
                  InkWell(
                    onTap: () {
                      final username = _nameController.text;
                      addUser(username);
                      QuizManager.setUserName(username);
                      Get.to(const QuizScreen());
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding:
                          const EdgeInsets.all(kDefaultPadding * 0.75), // 15
                      decoration: const BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Text(
                        "Lets Start Quiz",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2), // it will take 2/6 spaces
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
