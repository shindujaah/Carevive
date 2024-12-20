import 'package:flutter/material.dart';
import 'package:carevive/screens/dashboard/dashboard_screen.dart'; // Import the DashboardScreen
import 'package:carevive/utils/app_colors.dart'; // Import the AppColors

class FrontScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 90),
          Center(
            child: Image.asset(
              'assets/icons/logo.png', // Path to your logo
              width: 150, // Adjusted size
              height: 150, // Adjusted size
            ),
          ),
          SizedBox(height: 10),
          Text(
            'CareVive: Your Post-Chemo Companion',
            style: TextStyle(
              fontSize: 16, // Smaller font size
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
              fontStyle: FontStyle.italic,
            ),
          ),
          // Removed the SizedBox(height: 10) here
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton(context, 'My Symptoms', DashboardScreen(initialTab: 1)),
                  SizedBox(height: 4),
                  _buildButton(context, 'My Reminders', DashboardScreen(initialTab: 2)),
                  SizedBox(height: 4),
                  _buildButton(context, 'AI Chatbot', DashboardScreen(initialTab: 6)),
                  SizedBox(height: 4),
                  _buildButton(context, 'Cancer Resources', DashboardScreen(initialTab: 3)),
                  SizedBox(height: 4),
                  _buildButton(context, 'My Journal', DashboardScreen(initialTab: 4)),
                  SizedBox(height: 4),
                  _buildButton(context, 'My Profile', DashboardScreen(initialTab: 5)),
                  SizedBox(height: 10),
                  Text(
                    'CareVive @Cancer Care and Support Platform\nDeveloped by Shindujaah',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Widget screen) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8, // Adjusted width
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12), // Adjusted padding
          backgroundColor: Color.fromARGB(255, 83, 45, 151), // New button color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 2,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
