import 'package:flutter/material.dart';
import 'package:carevive/screens/chatbot/chatbot_screen.dart';
import 'package:carevive/screens/profile/user_profile.dart';
import 'package:carevive/screens/reminder/reminder_screen.dart';
import 'package:carevive/screens/resources_screen/resources_screen.dart';
import 'package:carevive/screens/journal/journalscreen.dart';
import 'package:carevive/screens/home/home_screen.dart';

class FrontScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          Center(
            child: Image.asset(
              'assets/icons/logo.png', // Path to your logo
              width: 200,
              height: 200,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'CareVive: Your Post-Chemo Companion',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text('My Cancer Support',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ));
                    },
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text('My Medication',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReminderScheduler(), // Corrected name
                          ));
                    },
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text('My Appointments',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatbotScreen(),
                          ));
                    },
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text('My Contacts',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JournalScreen(),
                          ));
                    },
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text('My Personal Information',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfile(),
                          ));
                    },
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text('Resources',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResourcesScreen(),
                          ));
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'CareVive @Cancer Care and Support Platform',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
