import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gonogo/gonogo_homepage.dart';
import 'package:gonogo/session_manager.dart';

class TapTestScreen extends StatefulWidget {
  final bool startInDifficultMode;
  final Duration duration;
  final Widget nextScreen;

  TapTestScreen({this.startInDifficultMode = false, required this.duration, required this.nextScreen});

  @override
  _TapTestScreenState createState() => _TapTestScreenState();
}

class _TapTestScreenState extends State<TapTestScreen> {
  bool isGo = false;
  bool showCircle = false;
  bool isIncreasedDifficulty = false;
  bool isTestRunning = false;
  bool isTestStopped = false;
  bool hasTapped = false;
  Timer? _timer;
  Timer? _displayTimer;
  bool isButtonDisabled = false;
  int score = 0;
  int goTapCount = 0;
  int noGoTapCount = 0;
  int totalTurns = 0;
  int maxTrackedTurns = 20;
  Random random = Random();
  Color circleColor = Colors.red;
  DateTime? turnStartTime;
  List<Map<String, dynamic>> responseTimes = [];
  Timer? _testTimer;
  int remainingTime = 0;

  final int normalDelay = 3;
  final int increasedDifficultyDelay = 1;

  @override
  void initState() {
    super.initState();
    isIncreasedDifficulty = widget.startInDifficultMode;
    remainingTime = widget.duration.inSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _displayTimer?.cancel();
    _testTimer?.cancel();
    super.dispose();
  }

  void endTest() {
    String modePrefix = isIncreasedDifficulty ? 'Difficult Mode' : 'Normal Mode';
    SessionDataManager().updateData('$modePrefix Tap Test Score', score);
    SessionDataManager().updateData('$modePrefix Tap Test Go Taps', goTapCount);
    SessionDataManager().updateData('$modePrefix Tap Test No-Go Taps', noGoTapCount);
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => widget.nextScreen));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 91, 150),
        title: Text('Tap Test',style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => GoNoGoHomePage()),
                (Route<dynamic> route) => false,
          ),
          tooltip: 'Back to Home',
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Text('$remainingTime s', style: TextStyle(fontSize: 22,color: Colors.white)),  
          )
        ],
      ),
      body: GestureDetector(
        onTap: isTestRunning ? _onTap : null,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showCircle) Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    isGo ? 'Go' : 'No-Go',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              if (!isTestRunning && !isTestStopped) // Show instructions only when the test is not running
                Center( // Explicitly center the Text widget
                  child: Text(
                    isIncreasedDifficulty
                        ? 'Difficult mode: Tap when you see a circle with "GO"!, regardless of colour.'
                        : 'Normal mode: Tap when you see "GO"!',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center, // Ensures the text is centered within the Text widget
                  ),
                ),
              SizedBox(height: 20),
              Text('Score: $score', style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              if (isTestStopped) ...[
                Text('Go Taps: $goTapCount', style: TextStyle(fontSize: 18)),
                Text('No-Go Taps: $noGoTapCount', style: TextStyle(fontSize: 18)),
                Text('Total Turns: $totalTurns', style: TextStyle(fontSize: 18)),
                ElevatedButton(
                  onPressed: _showResponseTimes,
                  child: Text('Show Timings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildBottomNavigationBar() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          ElevatedButton(
            onPressed:  isButtonDisabled ? null : _startTest,
            child: Text('Start', style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 2, 91, 150)),
          ),
          //SizedBox(width: 16),
         // ElevatedButton(
            //onPressed: _stopTest,
           // child: Text('Stop', style: TextStyle(color: Colors.black54)),
          // /style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF6767)),
        ],
      ),
    );
  }

  void _toggleDifficulty() {
    setState(() {
      isIncreasedDifficulty = !isIncreasedDifficulty;
    });
  }

  void _startNewTrial() {
    if (_timer != null) {
      _timer!.cancel(); // Always cancel existing timer before creating a new one
    }
    setState(() {
      isGo = random.nextBool();
      circleColor = isIncreasedDifficulty ? (random.nextBool() ? const Color.fromARGB(255, 2, 91, 150) : Colors.red) : (isGo ? Colors.blue : Colors.red);
      showCircle = true;
      hasTapped = false;
      turnStartTime = DateTime.now();
      totalTurns++;
    });

    _timer = Timer(Duration(seconds: isIncreasedDifficulty ? increasedDifficultyDelay : normalDelay), () {
      setState(() {
        showCircle = false;
      });
      if (remainingTime > 0) {
        _startNewTrial(); // Schedule the next trial
      }

    });
  }


  void _onTap() {
    if (!showCircle) return; // Ignore taps when no circle is shown

    final responseTime = DateTime.now().difference(turnStartTime!).inMilliseconds / 1000.0;
    _recordResponseTime(responseTime, isGo ? 'Go' : 'No-Go');
    hasTapped = true;

    if (_isCorrectTap()) {
      setState(() {
        score++;
        if (isGo) goTapCount++;
      });
    } else {
      setState(() {
        score--;
        if (!isGo) noGoTapCount++;
      });
    }

    // Immediately hide the circle and wait for the next trial
    setState(() {
      showCircle = false;
    });
  }

  void _recordResponseTime(double responseTime, String goOrNoGo) {
    if (responseTimes.length < maxTrackedTurns) {
      responseTimes.add({'time': responseTime, 'type': goOrNoGo});
    }
  }

  bool _isCorrectTap() {
    return isIncreasedDifficulty ? (isGo && (circleColor == Colors.blue || circleColor == Colors.red))
        : (isGo && circleColor == Colors.blue);
  }

  void _stopTest() {
    _timer?.cancel();
    _displayTimer?.cancel();
    setState(() {
      isTestRunning = false;
      isTestStopped = true;
    });
  }

  void _startTest() {
  setState(() {
    if (!isButtonDisabled) {
      score = 0;
      goTapCount = 0;
      noGoTapCount = 0;
      totalTurns = 0;
      responseTimes.clear();
      isTestRunning = true;
      isTestStopped = false;
      isButtonDisabled = true;  // Disable the button after it's pressed

      _testTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (remainingTime > 0) {
          setState(() {
            remainingTime--;
          });
        } else {
          timer.cancel();
          endTest();
        }
      });
    }
  });
  _startNewTrial();
}


  void _showResponseTimes() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Response Times (first 20 turns)'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 0; i < responseTimes.length; i++)
                  Text('Turn ${i + 1}: ${responseTimes[i]['time'].toStringAsFixed(4)} sec (${responseTimes[i]['type']})'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}