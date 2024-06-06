import 'package:carevive/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CancerTreatmentScreen extends StatelessWidget {
  final String uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CancerTreatmentScreen({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Cancer Treatment Details',
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestore.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    'Cancer Stage',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(data['cancerStage']),
                ),
                ListTile(
                  title: Text(
                    'Cancer Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(data['cancerType']),
                ),
                Divider(),
                Text(
                  'Treatment Progress',
                  style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                ListTile(
                  leading: Icon(
                    Icons.timelapse,
                    color: AppColors.secondaryColor1,
                  ),
                  title: Text(
                    'Cycles Done',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${data['cyclesDone']}'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.alarm,
                    color: AppColors.secondaryColor1,
                  ),
                  title: Text(
                    'Cycles Remaining',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${data['cyclesRemaining']}'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: AppColors.secondaryColor1,
                  ),
                  title: Text(
                    'Time of Illness (years)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${data['timeOfIllness']},'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
