import 'package:flutter/material.dart';
import 'package:gonogo/gonogo_homepage.dart';
import 'package:gonogo/session_manager.dart'; // Assuming the homepage is imported here

class GAD7Form extends StatefulWidget {
  @override
  _GAD7FormState createState() => _GAD7FormState();
}

class _GAD7FormState extends State<GAD7Form> {
  final _formKey = GlobalKey<FormState>();
  List<int> responses = List.filled(7, 0);
  
  late String scoreinterpretation;
  int get totalScore => responses.reduce((sum, item) => sum + item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GAD-7 Anxiety Test"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 91, 150),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: List.generate(7, (index) => buildQuestionTile(index)) +
              [
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      var clr = totalScore <= 4
                          ? Colors.blue
                          : totalScore <= 9
                              ? const Color.fromARGB(255, 246, 222, 8)
                              : totalScore <= 14
                                  ? Colors.orange
                                  : Colors.red;
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: const Center(
                              child: Text(
                            'Your Anxiety Score',
                            style: TextStyle(fontSize: 19),
                          )),
                          content: Container(
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  'Your GAD-7 score is',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  totalScore.toString(),
                                  style: TextStyle(color: clr, fontSize: 30, fontWeight: FontWeight.w600),
                                ),
                                const Text(
                                  "You Have ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  scoreInterpretation(totalScore),
                                  style: TextStyle(
                                      color: clr,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: const Color.fromARGB(255, 2, 91, 150), 
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                saveDataAndExit();
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color.fromARGB(
                        255, 2, 91, 150), 
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
        ),
      ),
    );
  }

  Widget buildQuestionTile(int index) {
    List<String> questions = [
      "Feeling nervous, anxious, or on edge",
      "Not being able to stop or control worrying",
      "Worrying too much about different things",
      "Trouble relaxing",
      "Being so restless that it is hard to sit still",
      "Becoming easily annoyed or irritable",
      "Feeling afraid as if something awful might happen"
    ];

    List<String> labels = [
      "0 - Not at all",
      "1 - Several days",
      "2 - More than half the days",
      "3 - Nearly every day"
    ];

    return ListTile(
      title: Text(
        '${index + 1}. ${questions[index]}',
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 33, 33, 33)),
      ),
      subtitle: Wrap(
        spacing: 8.0,
        children: List.generate(
            4,
            (score) => ChoiceChip(
                  label: Text(labels[score], style: const TextStyle(fontSize: 14,)),
                  selected: responses[index] == score,
                  side: BorderSide(
                      color: responses[index] == score
                          ? const Color.fromARGB(255, 2, 91, 150)
                          : Colors.transparent), 
                  selectedColor: const Color.fromARGB(255, 2, 91, 150),
                  backgroundColor: Colors.grey[200],
                  onSelected: (bool selected) {
                    setState(() {
                      responses[index] = selected ? score : responses[index];
                    });
                  },
                )),
      ),
    );
  }

  String scoreInterpretation(int score) {
    if (score <= 4){
      scoreinterpretation = "Minimal anxiety";
      return "Minimal anxiety";

    }
    else if (score <= 9) {
      scoreinterpretation = "Mild anxiety";
      return "Mild anxiety";

    }
    else if (score <= 14) {
      scoreinterpretation = "Moderate anxiety";
      return "Moderate anxiety";

    }else {
      scoreinterpretation = "Severe anxiety";
      return "Severe anxiety";

    }
  }

  void saveDataAndExit() {
    SessionDataManager().updateData('GAD-7 Score', totalScore);
    SessionDataManager().updateData('GAD-7 Interpretation', scoreinterpretation);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => GoNoGoHomePage()),
      (Route<dynamic> route) => false,
    );
  }
}
