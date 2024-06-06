import 'package:carevive/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'severity_widget.dart';

class LogSymptomsScreen extends StatefulWidget {
  final DateTime selectedDay;

  LogSymptomsScreen({required this.selectedDay});

  @override
  _LogSymptomsScreenState createState() => _LogSymptomsScreenState();
}

class _LogSymptomsScreenState extends State<LogSymptomsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _symptoms = [];
  final List<Map<String, String>> _availableSymptoms = [
    {'icon': 'assets/icons/Nausea.png', 'label': 'Nausea'},
    {'icon': 'assets/icons/Fatigue.png', 'label': 'Fatigue'},
    {'icon': 'assets/icons/Pain.png', 'label': 'Pain'},
    {'icon': 'assets/icons/Hair Loss.png', 'label': 'Hair Loss'},
    {'icon': 'assets/icons/Appetite Loss.png', 'label': 'Appetite Loss'}
  ];
  final List<ExpansionTileController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _availableSymptoms.forEach((symptom) {
      _symptoms.add({
        'label': symptom['label'],
        'icon': symptom['icon'],
        'severity': 'None',
        'notes': TextEditingController(),
        'isAdded': false,
      });
      _controllers.add(ExpansionTileController());
    });
  }

  void _toggleExpansion(int index) {
    setState(() {
      if (_controllers[index].isExpanded) {
        _controllers[index].collapse();
      } else {
        _controllers[index].expand();
        _symptoms[index]['isAdded'] = true;
      }
    });
  }

  void _removeSymptom(int index) {
    setState(() {
      _symptoms[index]['severity'] = 'None';
      _symptoms[index]['notes'].clear();
      _controllers[index].collapse();
      _symptoms[index]['isAdded'] = false;
    });
  }

  void _saveSymptoms() {
    if (_formKey.currentState!.validate()) {
      final symptomsData = _symptoms
          .where((symptom) =>
              symptom['isAdded'] &&
              (symptom['severity'] != 'None' ||
                  symptom['notes'].text.isNotEmpty))
          .map((symptom) {
        return {
          'label': symptom['label'],
          'severity': symptom['severity'],
          'notes': symptom['notes'].text,
        };
      }).toList();

      if (symptomsData.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('symptoms')
            .add({
          'symptoms': symptomsData,
          'date': widget.selectedDay,
        });
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('MMMM dd, yyyy').format(widget.selectedDay);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log Symptoms',
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 20,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Log symptoms for $formattedDate',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor1,
                  ),
                ),
              ),
              ..._symptoms.map((symptom) {
                int index = _symptoms.indexOf(symptom);
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black45),
                    ),
                  ),
                  child: ExpansionTile(
                    controller: _controllers[index],
                    leading: Image.asset(
                      symptom['icon']!,
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                    ),
                    title: Text(symptom['label']),
                    trailing: InkWell(
                      onTap: () {
                        _toggleExpansion(index);
                      },
                      child: Icon(
                        !_symptoms[index]['isAdded']
                            ? Icons.add
                            : _controllers[index].isExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                        color: AppColors.primaryColor1,
                      ),
                    ),
                    onExpansionChanged: (expanded) {
                      if (_controllers[index].isExpanded) {
                        _symptoms[index]['isAdded'] = true;
                      }
                      setState(() {});
                    },
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Severity',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(height: 12),
                            SeverityWidget(
                              severity: symptom['severity'],
                              onChanged: (value) {
                                setState(() {
                                  symptom['severity'] = value;
                                });
                              },
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                controller: symptom['notes'],
                                decoration: InputDecoration(
                                  labelText: 'Write notes for the symptom',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                maxLines: 3,
                              ),
                            ),
                            SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                _removeSymptom(index);
                              },
                              child: Row(
                                children: [
                                  Icon(CupertinoIcons.delete,
                                      color: Colors.redAccent),
                                  Text('Remove symptom',
                                      style:
                                          TextStyle(color: Colors.redAccent)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveSymptoms,
                  child: Text('Save Symptoms'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.primaryColor1,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Added Symptoms:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor1,
                  ),
                ),
              ),
              ..._symptoms
                  .where((symptom) => symptom['isAdded'])
                  .map((symptom) {
                return ListTile(
                  leading: Image.asset(symptom['icon']!, width: 24, height: 24),
                  title: Text(symptom['label']),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      int index = _symptoms.indexOf(symptom);
                      _removeSymptom(index);
                    },
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
