import 'package:carevive/model/reminder_model.dart';
import 'package:carevive/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

addAlertDialogue(BuildContext context, String uid) {
  String _selectType = "Exercise";
  DateTime? _selectedDateTime;
  final TextEditingController _descController = TextEditingController();
  TimeOfDay time = TimeOfDay.now();
  add(String uid, String type, String desc, DateTime time) {
    try {
      final now = DateTime.now();
      int newId = now.microsecondsSinceEpoch;
      int shortenId(int originalId) {
        return originalId % (1 << 31);
      }
      int Rid = shortenId(newId);
      Timestamp timestamp = Timestamp.fromDate(time);
      ReminderModel reminderModel = ReminderModel();
      reminderModel.Rid = Rid;
      reminderModel.type = type;
      reminderModel.desc = desc;
      reminderModel.timestamp = timestamp;
      reminderModel.onOff = false;
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('reminder')
          .doc()
          .set(reminderModel.toMap());
      Fluttertoast.showToast(msg: "Reminder Added");
    } catch (e) {
      print(e.toString());
    }
  }

  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            var media = MediaQuery.of(context).size;

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              title: Text("Add reminder"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: media.height * 0.02,
                    ),
                    Container(
                      height: 55,
                      padding: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrayColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: Text("Choose Type",
                                        style: const TextStyle(
                                            color: AppColors.grayColor,
                                            fontSize: 12)),
                                    value: _selectType,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectType = newValue!;
                                      });
                                    },
                                    items: [
                                      "Exercise",
                                      "Meals",
                                      "Medication",
                                      "Doctor Appointments",
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            color: AppColors.grayColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.height * 0.02,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.lightGrayColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        maxLines: 2,
                        controller: _descController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            labelText: "Description",
                            hintStyle: TextStyle(
                                fontSize: 12, color: AppColors.grayColor)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Description';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: media.height * 0.02,
                    ),

                    DateTimeField(
                      format: DateFormat("yyyy-MM-dd HH:mm"),
                      decoration:
                          InputDecoration(labelText: 'Select Date & Time'),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                      onChanged: (date) {
                        setState(() {
                          _selectedDateTime = date;
                        });
                      },
                    ),
                    // MaterialButton(
                    //   onPressed: () async {
                    //     TimeOfDay? newTime = await showTimePicker(
                    //         context: context, initialTime: TimeOfDay.now());
                    //     if (newTime == null) return;
                    //     setState(() {
                    //       time = newTime;
                    //     });
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         Icons.timer,
                    //         color: AppColors.primaryColor1,
                    //         size: 40,
                    //       ),
                    //       SizedBox(
                    //         width: 10,
                    //       ),
                    //       Text(
                    //         time.format(context).toString(),
                    //         style: TextStyle(
                    //             color: AppColors.primaryColor1, fontSize: 30),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      add(uid, _selectType, _descController.text,
                          _selectedDateTime!);
                      Navigator.of(context).pop();
                    },
                    child: Text("Add")),
              ],
            );
          },
        );
      });
}
