import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gonogo/break_screen.dart';
import 'package:gonogo/session_manager.dart';
import 'package:gonogo/test3_screen.dart';

class IQTestScreen extends StatefulWidget {
  @override
  _IQTestScreenState createState() => _IQTestScreenState();
}

class _IQTestScreenState extends State<IQTestScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  Timer? questionTimer;
  int timeLeft = 10;
  final int questionDuration = 10;

  final List<Map<String, dynamic>> questions = [
    {
      'questionText':
          'Which nos. should appear next in the series? 35, 33, 31, 29, ___, ___, 23 ?',
      'options': ['23, 21', '27, 25', '25, 23', '21, 23'],
      'correctAnswer': '27, 25'
    },
    {
      'questionText':
          'Which one of the 5 is least like the other four? Cow, camel, dog, horse, snake',
      'options': ['Snake', 'Cow', 'Camel', 'Dog'],
      'correctAnswer': 'Snake'
    },
    {
      'questionText':
          'If you rearrange the letters "BARBIT" you would have the name of an ocean, country, city, animal',
      'options': ['Ocean', 'Country', 'City', 'Animal'],
      'correctAnswer': 'Animal'
    },
    {
      'questionText':
          'Sami 12 years old now is 3 times as old as his brother. How old will Sami be when he is twice as old as his brother?',
      'options': ['15', '18', '16', '20'],
      'correctAnswer': '16'
    },
    {
      'questionText':
          'Which of the 5 alphabets is least like the other 4 (F, C, D, Z, E) ? ',
      'options': ['F', 'D', 'Z', 'E', 'C'],
      'correctAnswer': 'E'
    },
    {
      'questionText': 'How many corners are there in this shape?',
      'options': ['6', '7', '8', '9'],
      'correctAnswer': '9',
      'image': 'assets/Images/dodecahedron.png'
    },
    {
      'questionText': 'Give the place value of 6 in the number, 361489 ? ',
      'options': ['6', '60', '600', '6000', '60,000'],
      'correctAnswer': '60,000'
    },
    {
      'questionText':
          'When counting from 1 to 100 how many times will come across the number 5 ?',
      'options': ['18', '19', '20', '21'],
      'correctAnswer': '19'
    },
    {
      'questionText': 'If 3+5=10 and 5+5=8 then what does 3 equal to ?',
      'options': ['3', '4', '5', '6'],
      'correctAnswer': '6'
    },
    {
      'questionText':
          'Given the picture, if gear 4 turns clockwise, which other gear follows the same direction?',
      'options': ['1 only', '2 only', '1 and 3', '1, 2 and 3 only'],
      'correctAnswer': '1 and 3',
      'image': 'assets/Images/gears.png'
    },
  ];

  @override
  void initState() {
    super.initState();
    startQuestionTimer();
  }

  @override
  void dispose() {
    questionTimer
        ?.cancel(); // Ensure the timer is canceled when the widget is disposed
    super.dispose();
  }

  void startQuestionTimer() {
    setState(() {
      timeLeft = questionDuration;
    });
    questionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();

        if (currentQuestionIndex < questions.length - 1) {
          setState(() {
            currentQuestionIndex++;
          });
          // Restart the timer for the next question
          startQuestionTimer();
        } else {
          // Final question answered or time expired
          endTest();
        }
      }
    });
  }

  void answerQuestion(String selectedOption) {
    // Cancel current timer when the question is answered
    questionTimer?.cancel();
    if (questions[currentQuestionIndex]['correctAnswer'] == selectedOption) {
      score++;
    }
    // Move to next question or end test
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
      startQuestionTimer(); // Start a new timer for the next question
    } else {
      endTest();
    }
  }

  void endTest() {
    // Navigate to the break screen and pass the result
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => BreakScreen(
                duration: Duration(seconds: 15), nextScreen: Test3Screen())));
    SessionDataManager().updateData('IQ Test Score', score);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> currentQuestion = questions[currentQuestionIndex];
    List<String> options = currentQuestion['options'];

    return Scaffold(
      appBar: AppBar(
        title: Text('IQ Test 1', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 2, 91, 150), // AppBar color
        
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (currentQuestion.containsKey('image'))
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    currentQuestion['image'],
                    width: 120,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Time Left: $timeLeft',
                        style: TextStyle(
                            fontSize: 19,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  currentQuestion['questionText'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              Wrap(
                children: [
                  ...options
                      .map((option) => Container(
                            height: 45,
                            width: 150,
                            margin: EdgeInsets.all(2),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(12),
                                backgroundColor: const Color.fromARGB(
                                    255, 2, 91, 150), // Button background color
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () => answerQuestion(option),
                              child: Text(
                                option,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ))
                      .toList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
