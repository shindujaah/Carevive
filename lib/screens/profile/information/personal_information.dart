import 'package:carevive/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalInfoScreen extends StatelessWidget {
  final String uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  PersonalInfoScreen({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Personal Information',
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
                  title: Text(
                    '${data['firstName']} ${data['lastName']}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  subtitle:
                      Text('Age: ${data['age']} | Gender: ${data['gender']}'),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(
                    Icons.email,
                    color: AppColors.secondaryColor1,
                  ),
                  title: Text(data['email']),
                ),
                ListTile(
                  leading: Icon(
                    Icons.contact_phone,
                    color: AppColors.secondaryColor1,
                  ),
                  title: Text(data['number']),
                ),
                Divider(),
                Text(
                  'Caretaker Details',
                  style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: AppColors.secondaryColor1,
                  ),
                  title: Text(data['caretakerName']),
                  subtitle: Text(
                      'Age: ${data['caretakerAge']} | Relationship: ${data['caretakerRelationship']}'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.contact_phone,
                    color: AppColors.secondaryColor1,
                  ),
                  title: Text(data['caretakerContact']),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: AppColors.secondaryColor1,
                  ),
                  title: Text(data['caretakerAddress']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
