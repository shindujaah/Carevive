import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  int? Rid;
  String? type;
  String? desc;
  Timestamp? timestamp;
  bool? onOff;

  ReminderModel({this.Rid, this.type, this.desc, this.timestamp, this.onOff});

  Map<String, dynamic> toMap() {
    return {
      'Rid': Rid,
      'type': type,
      'desc': desc,
      'time': timestamp,
      'onOff': onOff,
    };
  }

  factory ReminderModel.fromMap(map) {
    return ReminderModel(
      Rid: map['Rid'],
      type: map['type'],
      desc: map['desc'],
      timestamp: map['time'],
      onOff: map['onOff'],
    );
  }
}
