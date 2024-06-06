import 'package:carevive/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthMetricsScreen extends StatelessWidget {
  final String uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  HealthMetricsScreen({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Health Metrics',
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 18,
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
                  leading: Icon(
                    Icons.fitness_center,
                    color: AppColors.secondaryColor1,
                  ),
                  title: Text('Weight'),
                  subtitle: Text('${data['weight']} kg'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.height,
                    color: AppColors.secondaryColor1,
                  ),
                  title: Text('Height'),
                  subtitle: Text('${data['height']} cm'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.opacity,
                    color: Colors.redAccent,
                  ),
                  title: Text('Blood Type'),
                  subtitle: Text(data['blood']),
                ),
                Divider(),
                Text(
                  'Health History',
                  style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                ListTile(
                  title: Text('Medical History'),
                  subtitle: Text(data['medicalHistory']),
                ),
                ListTile(
                  title: Text('Allergies'),
                  subtitle: Text(data['allergies']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
