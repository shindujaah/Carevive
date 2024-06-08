import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'note_editor.dart';
import 'note_reader.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  static const Color bgColor = Colors.white;
  static const Color mainColor = Color(0xFF000633);
  static const Color accentColor = Color(0xFF532D97);

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

  User? user;

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: bgColor,
    appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: bgColor,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "Journal",
        style: TextStyle(
            color: mainColor,
            fontSize: 16,
            fontWeight: FontWeight.w700),
      ),
    ),
    body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('Notes')
          .orderBy('creation_date', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("Nothing to show"));
        }
        final data = snapshot.data!;
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Image.asset('assets/icons/16.png'),
              GridView.builder(
                padding: const EdgeInsets.all(8.0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 1,
                ),
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
                  var note = data.docs[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteEditorScreen(note: note),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardsColor[index % cardsColor.length],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note['note_title'],
                              style: mainTitle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              DateFormat('yyyy-MM-dd hh:mm a').format(note['creation_date'].toDate()),
                              style: dateTitle,
                            ),
                            SizedBox(height: 8.0),
                            Expanded(
                              child: Text(
                                note['note_content'],
                                style: mainContent,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user!.uid)
                                      .collection('Notes')
                                      .doc(note.id)
                                      .delete();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    ),
  floatingActionButton: Container(
    width: 56.0,
    height: 56.0,
    child: RawMaterialButton(
      shape: CircleBorder(),
      elevation: 10.0,
      fillColor: Colors.transparent,
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NoteEditorScreen()));
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
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    ),
  ),
  );
}
}
