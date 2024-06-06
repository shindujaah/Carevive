import 'package:carevive/screens/dashboard/dashboard_screen.dart';
import 'package:carevive/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SymptomHistory extends StatelessWidget {
  final String userId;

  SymptomHistory({required this.userId});

  void _deleteSymptom(BuildContext context, String docId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('symptoms')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(),
                ));
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Symptom History',
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 20,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('symptoms')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: EdgeInsets.all(10),
            children: snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              DateTime date = (data['date'] as Timestamp).toDate();
              String formattedDate = DateFormat('MMMM dd, yyyy').format(date);
              List symptoms = data['symptoms'] ?? [];

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
                      SizedBox(height: 8),
                      ...symptoms.map<Widget>((symptom) {
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
                                  if (symptom['severity'] == "None")
                                    Icon(Icons.sentiment_very_dissatisfied,
                                        color: Colors.red),
                                  if (symptom['severity'] == "Mild")
                                    Icon(Icons.sentiment_dissatisfied,
                                        color: Colors.orange),
                                  if (symptom['severity'] == "Moderate")
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
          );
        },
      ),
    );
  }
}
