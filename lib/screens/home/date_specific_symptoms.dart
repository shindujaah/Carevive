import 'package:carevive/screens/dashboard/dashboard_screen.dart';
import 'package:carevive/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateSpecificSymptoms extends StatefulWidget {
  final String userId;
  final DateTime selectedDate;
  final List symptoms;

  DateSpecificSymptoms({
    required this.userId,
    required this.selectedDate,
    required this.symptoms,
  });

  @override
  State<DateSpecificSymptoms> createState() => _DateSpecificSymptomsState();
}

class _DateSpecificSymptomsState extends State<DateSpecificSymptoms> {
  void _deleteSymptom(BuildContext context, String docId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('symptoms')
        .doc(docId)
        .delete()
        .then((_) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('MMMM dd, yyyy').format(widget.selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Symptoms',
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 20,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: widget.symptoms.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          List symptomDetails = data['symptoms'] ?? [];

          return Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor1),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _deleteSymptom(context, doc.id),
                      )
                    ],
                  ),
                  ...symptomDetails.map<Widget>((symptom) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Image.asset(
                            'assets/icons/${symptom['label']}.png',
                            width: 24,
                            height: 24,
                          ),
                          title: Text(
                            symptom['label'],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                'Severity: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (symptom['severity'] == "Severe")
                                Icon(Icons.sentiment_very_dissatisfied,
                                    color: Colors.red),
                              if (symptom['severity'] == "Moderate")
                                Icon(Icons.sentiment_dissatisfied,
                                    color: Colors.orange),
                              if (symptom['severity'] == "Mild")
                                Icon(Icons.sentiment_neutral,
                                    color: Colors.blue),
                              if (symptom['severity'] == "Good")
                                Icon(Icons.sentiment_satisfied,
                                    color: Colors.green),
                              Text(' ${symptom['severity']}'),
                            ],
                          ),
                        ),
                        if (symptom['notes'] != null &&
                            symptom['notes'].isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              'Notes: ${symptom['notes']}',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
