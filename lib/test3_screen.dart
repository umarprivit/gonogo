import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gonogo/break_screen.dart';
import 'package:gonogo/iq_test_2_screen.dart';
import 'package:gonogo/session_manager.dart';
import 'package:gonogo/tap_test_screen.dart';

class Test3Screen extends StatefulWidget {
  @override
  _Test3ScreenState createState() => _Test3ScreenState();
}

class _Test3ScreenState extends State<Test3Screen> {
  String currentLetter = ''; // Start with an empty letter display
  int lastLetterScore = 0;
  int incorrectTaps = 0;
  List<String> letters = ['A', 'B', 'C', 'G'];
  Timer? letterTimer;
  List<String> lastThreeLetters = [];
  bool showLetter = true; 
  bool testStopped = false; 
  Timer? gameTimer;
  int remainingTime = 180; // Duration in seconds for the match game
  bool isTestRunning = false;

  void startLetterSequence() {
    letterTimer = Timer.periodic(Duration(milliseconds: 550), (timer) {
      if (remainingTime <= 0) {
        timer.cancel(); // Stop the timer if the remaining time is 0 or less
        stopLetterSequence();
      } else {
        updateLetterDisplay();
      }
    });
  }

  void updateLetterDisplay() {
    if (showLetter) {
      setState(() {
        currentLetter = letters[Random().nextInt(letters.length)];
        lastThreeLetters.add(currentLetter);
        if (lastThreeLetters.length > 2) {
          lastThreeLetters.removeAt(0);
        }
        showLetter = false;
      });
    } else {
      setState(() {
        currentLetter = '';
        showLetter = true;
      });
    }
  }

  void checkMatch() {
    if (lastThreeLetters.length >= 2 && lastThreeLetters[lastThreeLetters.length - 1] == lastThreeLetters[lastThreeLetters.length - 2]) {
      setState(() {
        lastLetterScore += 1;
      });
    } else {
      setState(() {
        incorrectTaps += 1;
      });
    }
  }

  void stopLetterSequence() {
    SessionDataManager().updateData('Match Test Score', lastLetterScore);
    SessionDataManager().updateData('Match Test Incorrect Taps', incorrectTaps);
    letterTimer?.cancel();
    setState(() {
      testStopped = true;
      currentLetter = '';
      isTestRunning = false;
    });
    // Navigate to the next screen
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BreakScreen(
        duration: Duration(seconds: 15),
        nextScreen: TapTestScreen(startInDifficultMode: true, duration: Duration(minutes: 3), nextScreen: BreakScreen(duration: Duration(seconds: 15), nextScreen: IQTestScreen2()))
    )));
  }

  void startTest() {
    setState(() {
      lastLetterScore = 0;
      incorrectTaps = 0;
      lastThreeLetters.clear();
      gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (remainingTime > 0) {
          setState(() {
            remainingTime--;
          });
        } else {
          timer.cancel();
          stopLetterSequence();
        }
      });

      isTestRunning = true;
      startLetterSequence();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 2, 91, 150),
        title: Text('Match Test', style: TextStyle(fontSize: 22, color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('$remainingTime s', style: TextStyle(fontSize: 22,color: Colors.white)),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: testStopped ? [
            Text('Test Ended', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Final Score: $lastLetterScore', style: TextStyle(fontSize: 20)),
            Text('Incorrect Taps: $incorrectTaps', style: TextStyle(fontSize: 20, color: Colors.red)),
          ] : [
            Text('Current Letter: $currentLetter', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            if (!isTestRunning)
              Text('Tap "Match" when you see alphabets appear in a row', style: TextStyle(fontSize: 14)),
            Text('Score: $lastLetterScore', style: TextStyle(fontSize: 20)),
            Text('Incorrect Taps: $incorrectTaps', style: TextStyle(fontSize: 20, color: Colors.red)),
            SizedBox(height: 20),
            if (!isTestRunning)
              ElevatedButton(
                onPressed: startTest,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                child: const Text('Start Test',
                    style: TextStyle(color: Colors.white)),
              ),
            if (isTestRunning)
              ElevatedButton(
                onPressed: checkMatch,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                child: const Text('Match',
                    style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}
