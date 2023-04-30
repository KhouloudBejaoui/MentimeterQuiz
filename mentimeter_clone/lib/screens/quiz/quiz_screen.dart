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




























/*class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key});

  @override
  State<StatefulWidget> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late QuestionController _controller;
  bool _isLoading = true;
  bool _isStatusTrue = false;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(QuestionController());

    _listenToQuestionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Flutter shows the back button automatically, we will disable it
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        /*actions: [
          TextButton(
            onPressed: _controller.nextQuestion,
            child: const Text("Skip"),
          ),
        ],*/
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isStatusTrue
              ? const Body()
              : const Center(child: CircularProgressIndicator()),
    );
  }

  void _listenToQuestionStatus() async {
    final response = await http.get(Uri.parse(
        'https://mentimeterclone-default-rtdb.firebaseio.com/questions/-NT_tTuqsvjfcPnMJ_gn/status.json'));

    if (response.statusCode == 200) {
      final status = json.decode(response.body) as bool;
      if (status) {
        setState(() {
          _isLoading = false;
          _isStatusTrue = true;
        });
      } else {
        Timer.periodic(const Duration(seconds: 1), (Timer t) async {
          final response = await http.get(Uri.parse(
              'https://mentimeterclone-default-rtdb.firebaseio.com/questions/-NT_tTuqsvjfcPnMJ_gn/status.json'));

          if (response.statusCode == 200) {
            final status = json.decode(response.body) as bool;
            if (status) {
              setState(() {
                _isLoading = false;
                _isStatusTrue = true;
              });
              t.cancel(); // stop the timer when the status becomes true
            }
          } else {
            setState(() {
              _isLoading = false;
            });
            throw Exception('Failed to load question');
          }
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load question');
    }
  }
}*/


/*    return FutureBuilder(
        future: controller.questions as Future<List<Question>>,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              var extractedData = snapshot.data as List<Question>;
              return Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  // Fluttter show the back button automatically, we will disable it
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  /*actions: [
                    TextButton(
                        onPressed: controller.nextQuestion,
                        child: const Text("Skip")),
                  ],*/
                ),
                body: const Body(),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(
            child: Text('No Data'),
          );
        });*/