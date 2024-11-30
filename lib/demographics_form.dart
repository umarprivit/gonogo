import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gonogo/gad7_form.dart';
import 'package:gonogo/session_manager.dart';

class DemographicsForm extends StatefulWidget {
  @override
  _DemographicsFormState createState() => _DemographicsFormState();
}

class _DemographicsFormState extends State<DemographicsForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> courseAnxiety = [];
  String? anxietyDiagnosis;
  String? gender;
  String? domicile;
  String? socialMediaTime;
  String? socialMediaUsage;
  String? sportsTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(8),
          ),
        ),
        title: const Text("Demographic Questions"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            buildRadioTile(
              'Are you diagnosed with any anxiety issues previously or under any medications?',
              'anxietyDiagnosis',
              ['Yes', 'No'],
            ),
            buildRadioTile('What is your gender?', 'gender', ['Male', 'Female', 'Prefer not to say']),
            buildRadioTile('Your domicile is from?', 'domicile', ['Urban', 'Rural']),
            buildCheckboxTile('Which type of course causes you most study anxiety?', 'courseAnxiety', [
              'Mathematics',
              'Theoretical courses',
              'Language courses',
              'Presentation courses',
              'Critical thinking courses',
              'Management courses',
              'Others'
            ]),
            buildRadioTile('How much time do you spend on usage of social media?', 'socialMediaTime', [
              'Less than 5 hours a day',
              '5 to 10 hours a day',
              'More than 10 hours a day'
            ]),
            buildRadioTile('How do you categorize your usage on social media as?', 'socialMediaUsage', ['Active', 'Passive']),
            buildRadioTile('How much time do you spend in outdoor sports activities per day?', 'sportsTime', [
              'Not at all',
              'Less than an hour',
              'More than an hour',
              'Very occasionally in a week',
              'Very occasionally in a month'
            ]),
            ElevatedButton(
              child: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
                disabledForegroundColor: Colors.grey,
                backgroundColor: const Color.fromARGB(255, 2, 91, 150),
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: 
                        submitForm
                        
                      
                    
                  
            ),
          ],
        ),
      ),
    );
  }

  bool canSubmit() {
    
    return anxietyDiagnosis != null &&
        gender != null &&
        domicile != null &&
        courseAnxiety.isNotEmpty &&
        socialMediaTime != null &&
        socialMediaUsage != null &&
        sportsTime != null;
  }

  Widget buildRadioTile(String question, String variable, List<String> options) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color.fromARGB(255, 33, 33, 33))),
          for (var option in options)
            GestureDetector(
              
              onTap: () => setState(() => this.setValue(variable, option)),
              child: ListTile(
                title: Text(option, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                leading: Radio<String>(
                  activeColor: const Color.fromARGB(255, 2, 91, 150),
                  value: option,
                  groupValue: this.reflectValue(variable),
                  onChanged: (value) => setState(() => this.setValue(variable, value)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildCheckboxTile(String question, String variable, List<String> options) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color.fromARGB(255, 33, 33, 33))),
          if (courseAnxiety.isEmpty) const Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Text('Please select at least one option', style: TextStyle(color: Colors.red, fontSize: 13)),
          ),
          for (var option in options)
            CheckboxListTile(
              activeColor: const Color.fromARGB(255, 2, 91, 150),
              title: Text(option, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              value: courseAnxiety.contains(option),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    courseAnxiety.add(option);
                  } else {
                    courseAnxiety.remove(option);
                  }
                });
              },
            ),
        ],
      ),
    );
  }

  String? reflectValue(String variable) {
    switch (variable) {
      case 'anxietyDiagnosis':
        return anxietyDiagnosis;
      case 'gender':
        return gender;
      case 'domicile':
        return domicile;
      case 'socialMediaTime':
        return socialMediaTime;
      case 'socialMediaUsage':
        return socialMediaUsage;
      case 'sportsTime':
        return sportsTime;
      default:
        return null;
    }
  }

  void setValue(String variable, String? value) {
    switch (variable) {
      case 'anxietyDiagnosis':
        anxietyDiagnosis = value;
        break;
      case 'gender':
        gender = value;
        break;
      case 'domicile':
        domicile = value;
        break;
      case 'socialMediaTime':
        socialMediaTime = value;
        break;
      case 'socialMediaUsage':
        socialMediaUsage = value;
        break;
      case 'sportsTime':
        sportsTime = value;
        break;
    }
    setState(() {}); 
  }

  bool checkFormCompletion() {
    // Check if all required fields are filled
    return anxietyDiagnosis != null && gender != null && domicile != null && socialMediaTime != null && socialMediaUsage != null && sportsTime != null && courseAnxiety.isNotEmpty;
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      SessionDataManager().updateData('Anxiety Diagnosis', anxietyDiagnosis);
      SessionDataManager().updateData('Gender', gender);
      SessionDataManager().updateData('Domicile', domicile);
      SessionDataManager().updateData('Social Media Usage', socialMediaUsage);
      SessionDataManager().updateData('Sports Time', sportsTime);
      SessionDataManager().updateData('Course Anxiety', courseAnxiety.join(', '));
      if (!checkFormCompletion()) {
        // Alert the user if the form is not completely filled
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Incomplete Form"),
              content: Text("Please answer all the questions before submitting."),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      } else {
        if (anxietyDiagnosis == 'Yes') {
          SystemNavigator.pop();
        } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => GAD7Form()));
          }
        }
      }
    }
}
