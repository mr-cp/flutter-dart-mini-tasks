import 'package:flutter/material.dart';
import 'package:image_gallaery/quiz_app.dart';

import 'package:image_gallaery/user_detail_fetching.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: QuizApp());
  }
}
