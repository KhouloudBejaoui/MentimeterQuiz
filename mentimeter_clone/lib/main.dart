import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mentimeter_clone/screens/welcome/code_screen.dart';
import 'firebase_options.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mentimeter Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CodeScreen(),
    );
  }
}
