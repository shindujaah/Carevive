import 'dart:async';

import 'package:carevive/screens/home/date_specific_symptoms.dart';
import 'package:carevive/screens/home/symptom_history.dart';
import 'package:carevive/screens/home/symptom_input_screen.dart';
import 'package:carevive/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class HomeScreen extends StatefulWidget {
  static String routeName = "/HomeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // late Stream<StepCount> _stepCountStream;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  late String uid;
  String firstName = '';
  String lastName = '';
  String blood = '';
  double weight = 0;
  double height = 0;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<dynamic>> _symptomsByDate = {};

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _fetchLoggedDates();
  }

  void _fetchLoggedDates() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('symptoms')
        .get()
        .then((querySnapshot) {
      Map<DateTime, List<dynamic>> tempSymptomsByDate = {};
      querySnapshot.docs.forEach((doc) {
        DateTime date = (doc['date'] as Timestamp).toDate();
        DateTime formattedDate = DateTime(date.year, date.month, date.day);
        if (tempSymptomsByDate[formattedDate] == null) {
          tempSymptomsByDate[formattedDate] = [];
        }
        tempSymptomsByDate[formattedDate]!.add(doc);
      });

      setState(() {
        _symptomsByDate = tempSymptomsByDate;
      });
    });
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    DateTime formattedDate = DateTime(day.year, day.month, day.day);
    return _symptomsByDate[formattedDate] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    if (_getEventsForDay(selectedDay).isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DateSpecificSymptoms(
            userId: _auth.currentUser!.uid,
            selectedDate: selectedDay,
            symptoms: _getEventsForDay(selectedDay),
          ),
        ),
      );
    } else {
      _showSymptomInputForm();
    }
  }

  void _showSymptomInputForm() {
    showDialog(
      context: context,
      builder: (context) => LogSymptomsScreen(
        selectedDay: _selectedDay,
      ),
    ).then((_) =>
        _fetchLoggedDates()); // Refresh the calendar after logging symptoms
  }

  Future<void> fetchUserData() async {
    int retries = 3;
    while (retries > 0) {
      try {
        // Get the current user
        user = _auth.currentUser;
        if (user != null) {
          // Get user details
          uid = user!.uid;
          DocumentSnapshot userSnapshot =
              await _firestore.collection('users').doc(uid).get();

          setState(() {
            firstName = userSnapshot['firstName'] ?? '';
            lastName = userSnapshot['lastName'] ?? '';
            blood = userSnapshot['blood'] ?? '';
            weight = double.parse(userSnapshot['weight']);
            height = double.parse(userSnapshot['height']);
          });
        }

        return; // Operation succeeded
      } catch (e) {
        retries--;
        await Future.delayed(Duration(seconds: 5)); // Retry after 5 seconds
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return SafeArea(
      child: PopScope(
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back,",
                            style: TextStyle(
                              color: AppColors.midGrayColor,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            firstName + " " + lastName,
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 20,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Container(
                    height: media.height * 0.2,
                    width: media.width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFFFAF0DB),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Temperature",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 18,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "35.5",
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 35,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Image.asset(
                            "assets/icons/temp.png",
                            height: media.height * 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: media.height * 0.17,
                        width: media.width / 2.4,
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFF5E1E9),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/icons/blood_icon.png",
                              height: media.height * 0.05,
                              color: Color(0xFF9D4C6C),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Blood",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 16,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              blood,
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 30,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: media.height * 0.17,
                        width: media.width / 2.4,
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFDCEDF9),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/icons/weight_icon.png",
                              height: media.height * 0.05,
                              color: Color(0xFF1969A3),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Weight",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 16,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              weight.toString(),
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 30,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Center(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.history),
                      label: Text('View Symptom History'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor1,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SymptomHistory(userId: _auth.currentUser!.uid),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.03,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                      ),
                      border: Border.all(
                        color: AppColors.primaryColor1,
                      ),
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: _onDaySelected,
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      eventLoader: _getEventsForDay,
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                          if (events.isNotEmpty) {
                            return Positioned(
                              right: 5,
                              bottom: 2,
                              child: _buildEventsMarker(date, events),
                            );
                          }
                        },
                        selectedBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(6.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor1,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            date.day.toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                        todayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(6.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor1.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            date.day.toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        titleTextStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor1,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        headerPadding: EdgeInsets.symmetric(vertical: 8.0),
                        headerMargin: EdgeInsets.only(bottom: 8),
                        formatButtonTextStyle: TextStyle(color: Colors.white),
                        formatButtonDecoration: BoxDecoration(
                          color: AppColors.primaryColor1,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        leftChevronIcon:
                            Icon(Icons.chevron_left, color: Colors.white),
                        rightChevronIcon:
                            Icon(Icons.chevron_right, color: Colors.white),
                      ),
                      calendarStyle: CalendarStyle(
                        isTodayHighlighted: true,
                        selectedDecoration: BoxDecoration(
                          color: AppColors.primaryColor1,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppColors.primaryColor1,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        markerDecoration: BoxDecoration(
                          color: AppColors.primaryColor1,
                          shape: BoxShape.circle,
                        ),
                        outsideDaysVisible: false,
                        weekendTextStyle:
                            TextStyle(color: AppColors.primaryColor1),
                        defaultTextStyle: TextStyle(color: Colors.black),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        weekendStyle: TextStyle(
                            color: AppColors.primaryColor1,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      width: 14.0,
      height: 14.0,
    );
  }
}
