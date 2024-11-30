import 'package:flutter/material.dart';
import 'package:gonogo/session_manager.dart';

class Copyright extends StatefulWidget {
  @override
  _Copyright createState() => _Copyright();
}

class _Copyright extends State<Copyright> {
  List<String> results = [];

  void _displayResults() {
    setState(() {
      results = SessionDataManager().getAllResults();
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
        backgroundColor: const Color.fromARGB(
                                    255, 2, 91, 150),
        title: const Text(
          "Copyright Statement",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "This work is part of NRPU project no: 15283 (awarded by HEC to Iqra University), entitled: “To estimate the prevalence of anxiety, depression and their associated risk factors among students of public and private sector institutions of Pakistan” and is repository to Iqra University, Faculty of Engineering Sciences and Technology, Karachi, Pakistan.",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              "PRINCIPAL INVESTIGATOR",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
            ),
            Text(
              "  Engr. Ikram E Khuda (FEST, IU)",
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 15),
            Text(
              "CO-PRINCIPAL INVESTIGATOR",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
            ),
            Text(
              "  Engr. Azeem Aftab (FEST, IU)",
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 15),
            Text(
              "DEVELOPERS",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
            ),
            Text(
              "  Muhammad Zain, Maham Noor, Sajid Hasan ",
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 15),
            Text(
              "DATA COLLECTION AND CONSOLIDATION",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
            ),
            Text(
              " Awais Ali ",
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _displayResults,
              child: Text('Display Results'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            ...results.map((result) => Text(result, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))).toList(),
          ],
        ),
      ),
    );
  }
}
