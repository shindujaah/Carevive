import 'package:flutter/material.dart';
import 'package:carevive/screens/dashboard/dashboard_screen.dart'; // Import the DashboardScreen

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
            'Support for Cancer Patients',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
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
                    title: Text('My Symptoms',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.purple),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(initialTab: 1),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text('My Reminders',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.purple),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(initialTab: 2),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text('AI Chatbot',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.purple),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(initialTab: 6),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text('Cancer Resources',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.purple),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(initialTab: 3),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text('My Journal',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.purple),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(initialTab: 4),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text('My Profile',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.purple),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(initialTab: 5),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
