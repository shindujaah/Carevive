import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteEditorScreen extends StatefulWidget {
  final QueryDocumentSnapshot? note;
  const NoteEditorScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late int colorId;
  late String date;
  late TextEditingController _titleController;
  late TextEditingController _mainController;
  User? user;

  static const List<Color> cardsColor = [
    Color(0xFFEAC1FF),
    Color(0xFFD49AFF),
    Color(0xFFCB6BFF),
    Color(0xFFE1AFD1),
    Color(0xFFAD88C6),
    Color(0xFF7469B6),
    Color(0xFF922EB5),
    Color.fromARGB(255, 198, 118, 222),
  ];

  static const TextStyle mainTitle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );

  static const TextStyle mainContent = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );

  static const TextStyle dateTitle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  );

  static const Color accentColor = Color(0xFF532D97);

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    colorId = widget.note != null
        ? widget.note!['color_id']
        : Random().nextInt(cardsColor.length);
    date = widget.note != null
        ? DateFormat('yyyy-MM-dd hh:mm a').format(widget.note!['creation_date'].toDate())
        : DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now());
    _titleController = TextEditingController(text: widget.note?['note_title'] ?? '');
    _mainController = TextEditingController(text: widget.note?['note_content'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardsColor[colorId],
      appBar: AppBar(
        backgroundColor: cardsColor[colorId],
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Add a new Note',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .collection('Notes')
                    .doc(widget.note!.id)
                    .delete()
                    .then((value) {
                  Navigator.pop(context);
                });
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Note Title'),
              style: mainTitle,
            ),
            SizedBox(height: 8.0),
            Text(
              date,
              style: dateTitle,
            ),
            SizedBox(height: 28.0),
            Expanded(
              child: TextField(
                controller: _mainController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note Content',
                ),
                style: mainContent,
              ),
            )
          ],
        ),
      ),
    floatingActionButton: Container(
      width: 56.0,
      height: 56.0,
      child: RawMaterialButton(
        shape: CircleBorder(),
        elevation: 10.0,
        fillColor: Colors.transparent,
        onPressed: () {
          if (widget.note == null) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .collection('Notes')
                .add({
              "note_title": _titleController.text,
              "creation_date": Timestamp.now(),
              "note_content": _mainController.text,
              "color_id": colorId
            }).then((value) {
              Navigator.pop(context);
            }).catchError(
                (error) => print("Failed to add new Note due to $error"));
          } else {
            FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .collection('Notes')
                .doc(widget.note!.id)
                .update({
              "note_title": _titleController.text,
              "note_content": _mainController.text,
              "creation_date": Timestamp.now(), // Update the timestamp
            }).then((value) {
              Navigator.pop(context);
            }).catchError(
                (error) => print("Failed to update Note due to $error"));
          }
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF922EB5), Color(0xFF6D1A87)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Icon(Icons.save, color: Colors.white),
          ),
        ),
      ),
    ),
    );
  }
}
