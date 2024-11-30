import 'dart:async';

import 'package:flutter/material.dart';

class BreakScreen extends StatefulWidget {
  final Duration duration;
  final Widget nextScreen;

  BreakScreen({required this.duration, required this.nextScreen});

  @override
  _BreakScreenState createState() => _BreakScreenState();
}

class _BreakScreenState extends State<BreakScreen> {
  Timer? _breakTimer;
  int remainingTime = 0;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.duration.inSeconds;
    _breakTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => widget.nextScreen));
      }
    });
  }

  @override
  void dispose() {
    _breakTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(title: Text("Break"),backgroundColor: Color.fromARGB(255, 255, 255, 255), ),
      body: Center(
        child: Text("Break time: $remainingTime seconds", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}