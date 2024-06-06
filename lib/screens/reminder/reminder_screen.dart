import 'package:carevive/common%20widgets/add_reminder_alert.dart';
import 'package:carevive/common%20widgets/reminder_delete.dart';
import 'package:carevive/common%20widgets/switch.dart';
import 'package:carevive/services/notification_logic.dart';
import 'package:carevive/utils/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ReminderScheduler extends StatefulWidget {
  @override
  State<ReminderScheduler> createState() => _ReminderSchedulerState();
}

class _ReminderSchedulerState extends State<ReminderScheduler> {
  User? user;
  bool on = true;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    NotificationLogic.init(context, user!.uid);
    listenNotifications();
  }

  void listenNotifications() {
    NotificationLogic.onNotifications.listen((value) {});
  }

  void onClickedNotification(String? payload) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ReminderScheduler()));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          title: const Text(
            "Schedule Reminders",
            style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          onPressed: () async {
            addAlertDialogue(context, user!.uid);
          },
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: AppColors.primaryG,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
                borderRadius: BorderRadius.circular(100),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(0, 2))
                ]),
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .collection('reminder')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xff4FA8C5)),
                  ),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(child: Text("Nothing to show"));
              }
              final data = snapshot.data;
              return ListView.builder(
                  itemCount: data?.docs.length,
                  itemBuilder: (context, index) {
                    Timestamp t = data?.docs[index].get('time');
                    String type = data?.docs[index].get('type');
                    String desc = data?.docs[index].get('desc');
                    int Rid = data?.docs[index].get('Rid');
                    DateTime dateTime = t.toDate();
                    final DateFormat dateFormatter =
                        DateFormat('yyyy-MM-dd : hh:mm');
                    String dt = dateFormatter.format(dateTime);
                    DateTime date = DateTime.fromMicrosecondsSinceEpoch(
                        t.microsecondsSinceEpoch);

                    String formattedTime = DateFormat.jm().format(date);
                    on = data!.docs[index].get('onOff');
                    if (on) {
                      NotificationLogic.showNotification(
                        dateTime: date,
                        id: Rid,
                        title: type,
                        body: desc,
                      );
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  type,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      desc,
                                    ),
                                    Text(
                                      dt,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  width: 110,
                                  child: Row(
                                    children: [
                                      Switcher(
                                          on,
                                          user!.uid,
                                          data.docs[index].id,
                                          data.docs[index].get('time'),
                                          Rid,
                                          type,
                                          desc),
                                      IconButton(
                                          onPressed: () {
                                            reminderDeleteAlertDialogue(context,
                                                data.docs[index].id, user!.uid);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
