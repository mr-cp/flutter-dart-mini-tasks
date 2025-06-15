// 🧠 Task 4: Quiz App:::::

import 'package:flutter/material.dart';

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  int currentIndex = 0;
  int score = 0;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(questionList[currentIndex].questionText),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 230,
                child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 3,
                    ),
                    itemBuilder: (context, index) {
                      final isCorrect = index ==
                          questionList[currentIndex].correctAnswerIndex;
                      final isSelected = selectedIndex == index;

                      Color getOptionColor() {
                        if (selectedIndex == null) return Colors.transparent;
                        if (isCorrect) return Colors.green;
                        if (isSelected) return Colors.red;
                        return Colors.transparent;
                      }

                      return InkWell(
                        onTap: selectedIndex == null
                            ? () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              }
                            : null,
                        child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                            color: getOptionColor(),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.cyan),
                          ),
                          child: Center(
                            child: Text(
                              questionList[currentIndex].options[index],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Text(
              score.toString(),
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Next",
        onPressed: () {
          setState(() {
            if (selectedIndex == null) return;
            if (selectedIndex ==
                questionList[currentIndex].correctAnswerIndex) {
              score++;
            }
          });
          if (currentIndex < questionList.length - 1) {
            setState(() {
              currentIndex++;
              selectedIndex = null;
            });
          } else {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ScoreScreen(score: score, outOf: questionList.length);
              },
            )).then((result) {
              if (result == 'restart') {
                setState(() {
                  currentIndex = 0;
                  score = 0;
                  selectedIndex = null;
                });
              }
            });
          }
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

// Example list of questions
final List<Question> questionList = [
  Question(
    questionText: 'What is the capital of France?',
    options: ['Berlin', 'Madrid', 'Paris', 'Lisbon'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'Which planet is known as the Red Planet?',
    options: ['Earth', 'Venus', 'Mars', 'Jupiter'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'Who wrote "Romeo and Juliet"?',
    options: [
      'Charles Dickens',
      'William Shakespeare',
      'Mark Twain',
      'Leo Tolstoy'
    ],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: 'Which gas do plants absorb from the atmosphere?',
    options: ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'What is the largest mammal in the world?',
    options: ['Elephant', 'Giraffe', 'Blue Whale', 'Hippopotamus'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'How many continents are there?',
    options: ['5', '6', '7', '8'],
    correctAnswerIndex: 2,
  ),
  Question(
    questionText: 'Which is the longest river in the world?',
    options: ['Amazon', 'Nile', 'Yangtze', 'Mississippi'],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: 'What is H2O commonly known as?',
    options: ['Salt', 'Oxygen', 'Hydrogen', 'Water'],
    correctAnswerIndex: 3,
  ),
  
];

class ScoreScreen extends StatefulWidget {
  final int score;
  final int outOf;

  const ScoreScreen({
    super.key,
    required this.score,
    required this.outOf,
  });

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              ' ${widget.score.toString()}/${widget.outOf}',
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(height: 50),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'restart');
              },
              child: Text('Restart Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
