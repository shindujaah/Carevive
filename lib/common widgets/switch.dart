import 'package:carevive/model/reminder_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Switcher extends StatefulWidget {
  bool onOff;
  int Rid;
  String type;
  String desc;
  String uid;
  Timestamp timestamp;
  String id;

  Switcher(this.onOff, this.uid, this.id, this.timestamp, this.Rid, this.type, this.desc);

  @override
  State<Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      
      onChanged: (bool value) {
        ReminderModel reminderModel = ReminderModel();
        reminderModel.onOff = value;
        reminderModel.timestamp = widget.timestamp;
        reminderModel.Rid = widget.Rid;
        reminderModel.desc = widget.desc;
        reminderModel.type = widget.type;
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .collection('reminder')
            .doc(widget.id)
            .update(reminderModel.toMap());
      },
      value: widget.onOff,
    );
  }
}
