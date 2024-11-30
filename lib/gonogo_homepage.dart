import 'package:flutter/material.dart';
import 'package:gonogo/break_screen.dart';
import 'package:gonogo/copyright_screen.dart';
import 'package:gonogo/iq_test_screen.dart';
import 'package:gonogo/tap_test_screen.dart';
import 'package:gonogo/test3_screen.dart';

class GoNoGoHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 91, 150),
        centerTitle: true,
        title: const Text(
          'Anxiety Test',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                startTestSequence(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: const Color.fromARGB(255, 2, 91, 150),
              ),
              child: Container(
                padding: const EdgeInsets.all(8),
                width: 180,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Begin Anxiety Test",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Icon(Icons.touch_app_rounded, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // If you want to add more buttons in the future, you can do so here.
          ],
        ),
      ),
    );
  }

  void startTestSequence(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => TapTestScreen(startInDifficultMode: false, duration: Duration(minutes: 3), nextScreen: BreakScreen(duration: Duration(seconds: 15), nextScreen: IQTestScreen()))));
  }
}
