import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;

  const ResultScreen({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(title: Text('Test Complete'),centerTitle: true,backgroundColor: Colors.transparent,),
      body: Center(
        child: Text('Your score: $score', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}