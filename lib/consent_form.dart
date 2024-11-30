import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gonogo/demographics_form.dart';

class ConsentForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Consent Form",style: TextStyle(fontSize: 24),),centerTitle: true,backgroundColor: Colors.transparent,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Center(
                child: Icon(Icons.assignment,
                    size: 120, color: Color.fromARGB(255, 2, 91, 150))),
            const SizedBox(height: 20),
            const Text("PURPOSE OF STUDY",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 2,
            ),
            const Text(
                "The purpose of this study is to estimate the degree and level of anxiety particularly focus test among the university students of Pakistan.",
                style: TextStyle(fontSize: 16)),
            const SizedBox(
              height: 20,
            ),
            const Text("STUDY PROCEDURES",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 2,
            ),
            const Text(
                "After answering a few demographic questions and filling out an anxiety scale, you will be asked to play a short game on a mobile app and during this, we will use some body sensors to measure anxiety levels that change while you play the game.",
                style: TextStyle(fontSize: 16)),
            const SizedBox(
              height: 20,
            ),
            const Text("RISKS",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 2,
            ),
            const Text(
                "There are no health risks in this study. However, if you feel uncomfortable at any time, you are allowed to quit and leave.",
                style: TextStyle(fontSize: 16)),
            const SizedBox(
              height: 20,
            ),
            const Text("CONFIDENTIALITY",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 2,
            ),
            const Text(
                "Your responses and results will be kept anonymous. Please do not write any identifying information. Every effort will be made by the researcher to preserve your confidentiality including the following:",
                style: TextStyle(fontSize: 16)),
            const SizedBox(
              height: 20,
            ),
            const Text("VOLUNTARY PARTICIPATION",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 2,
            ),
            const Text(
                "I understand the provided information and I understand that my participation in this research study is voluntary.",
                style: TextStyle(fontSize: 16)),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                          color: Color.fromARGB(255, 226, 134, 128), width: 1)),
                  child: const Text(
                    'Disagree and Exit',
                    style: TextStyle(color: Color.fromARGB(255, 236, 88, 77)),
                  ),
                  onPressed: () => SystemNavigator.pop(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color.fromARGB(255, 2, 91, 150)),
                  child: const Text(
                    'Agree and Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => DemographicsForm())),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
