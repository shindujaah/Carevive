import 'dart:io';

import 'package:carevive/screens/chatbot/chatbot_screen.dart';
import 'package:carevive/screens/profile/user_profile.dart';
import 'package:carevive/screens/reminder/reminder_screen.dart';
import 'package:carevive/screens/resources_screen/resources_screen.dart';
import 'package:carevive/screens/home/frontscreen.dart'; // Import the new screen
import 'package:carevive/screens/journal/journalscreen.dart'; // Import the new screen
import 'package:carevive/screens/home/home_screen.dart'; // Import the home screen
import 'package:carevive/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  static String routeName = "/DashboardScreen";
  final int initialTab;

  const DashboardScreen({Key? key, this.initialTab = 0}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int selectTab;

  @override
  void initState() {
    super.initState();
    selectTab = widget.initialTab;
  }

  final List<Widget> _widgetOptions = <Widget>[
    FrontScreen(), // Home front screen
    HomeScreen(), // Symptoms home screen
    ReminderScheduler(), // Reminder screen
    ResourcesScreen(), // Resources screen
    JournalScreen(), // Journal screen
    UserProfile(), // User profile screen
    ChatbotScreen(), // AI Chatbot screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(initialTab: 6),
            ),
          );
        },
        child: Container(
          width: 60,
          height: 60,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.primaryG),
              borderRadius: BorderRadius.circular(35),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 2)
              ]),
          child: Image.asset(
            "assets/icons/chatbot.png",
            height: 20,
            width: 20,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: IndexedStack(
        index: selectTab,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomAppBar(
        height: Platform.isIOS ? 70 : 65,
        color: Colors.transparent,
        padding: const EdgeInsets.all(0),
        child: Container(
          height: Platform.isIOS ? 70 : 65,
          decoration: const BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 2, offset: Offset(0, -2))
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                  icon: "assets/icons/home.png", // Home front icon
                  selectIcon: "assets/icons/home.png", // Home front icon
                  isActive: selectTab == 0,
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        selectTab = 0;
                      });
                    }
                  }),
              TabButton(
                  icon: "assets/icons/symptoms.png", // Symptoms home icon
                  selectIcon: "assets/icons/symptoms.png", // Symptoms home icon
                  isActive: selectTab == 1,
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        selectTab = 1;
                      });
                    }
                  }),
              TabButton(
                  icon: "assets/icons/reminder.png", // Reminder icon
                  selectIcon: "assets/icons/reminder.png", // Reminder icon
                  isActive: selectTab == 2,
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        selectTab = 2;
                      });
                    }
                  }),
              const SizedBox(width: 30),
              TabButton(
                  icon: "assets/icons/resources.png", // Resources icon
                  selectIcon: "assets/icons/resources.png", // Resources icon
                  isActive: selectTab == 3,
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        selectTab = 3;
                      });
                    }
                  }),
              TabButton(
                  icon: "assets/icons/journal.png", // Journal icon
                  selectIcon: "assets/icons/journal.png", // Journal icon
                  isActive: selectTab == 4,
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        selectTab = 4;
                      });
                    }
                  }),
              TabButton(
                  icon: "assets/icons/user_icon.png", // User profile icon
                  selectIcon: "assets/icons/user_select_icon.png", // User profile icon
                  isActive: selectTab == 5,
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        selectTab = 5;
                      });
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String icon;
  final String selectIcon;
  final bool isActive;
  final VoidCallback onTap;

  const TabButton(
      {Key? key,
      required this.icon,
      required this.selectIcon,
      required this.isActive,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isActive ? selectIcon : icon,
            width: 25,
            height: 25,
            fit: BoxFit.fitWidth,
            color: isActive ? AppColors.primaryColor1 : AppColors.grayColor,
          ),
          SizedBox(height: isActive ? 8 : 12),
          Visibility(
            visible: isActive,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.secondaryG),
                  borderRadius: BorderRadius.circular(2)),
            ),
          )
        ],
      ),
    );
  }
}
