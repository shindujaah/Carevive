import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteReaderScreen extends StatefulWidget {
  final QueryDocumentSnapshot doc;
  NoteReaderScreen(this.doc, {Key? key}) : super(key: key);

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
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

  @override
  Widget build(BuildContext context) {
    int colorId = widget.doc['color_id'];
    return Scaffold(
      backgroundColor: cardsColor[colorId],
      appBar: AppBar(
        backgroundColor: cardsColor[colorId],
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('Notes')
                  .doc(widget.doc.id)
                  .delete()
                  .then((value) {
                Navigator.pop(context);
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.doc["note_title"],
              style: mainTitle,
            ),
            SizedBox(height: 4.0),
            Text(
              DateFormat('yyyy-MM-dd hh:mm a').format(widget.doc["creation_date"].toDate()),
              style: dateTitle,
            ),
            SizedBox(height: 28.0),
            Text(
              widget.doc["note_content"],
              style: mainContent,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
