import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'components/body.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<StatefulWidget> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late DatabaseReference _ref;

  @override
  void initState() {
    super.initState();
    _ref = FirebaseDatabase.instance.ref().child('questions/active');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: _ref.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          }

          final status = snapshot.data?.snapshot.value ?? false;

          if (status == true) {
            return const Body();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
