import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppStyle {
  static List<Color> cardsColor = [
    Color(0xFFEAC1FF),
    Color(0xFFD49AFF),
    Color(0xFFCB6BFF),
    Color(0xFFE1AFD1),
    Color(0xFFAD88C6),
    Color(0xFF7469B6),
    Color(0xFF922EB5),
    Color.fromARGB(255, 198, 118, 222),
  ];

  static TextStyle mainTitle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );

  static TextStyle mainContent = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    fontFamily: 'Poppins',
  );

  static TextStyle dateTitle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  );
}

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc) {
  int colorId = doc['color_id'];
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: AppStyle.cardsColor[colorId],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doc["note_title"],
            style: AppStyle.mainTitle.copyWith(
              color: colorId < 3 ? Colors.black : Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.0),
          Text(
            DateFormat('yyyy-MM-dd hh:mm a').format(doc["creation_date"].toDate()),
            style: AppStyle.dateTitle.copyWith(
              color: colorId < 3 ? Colors.black : Colors.white,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            doc["note_content"],
            style: AppStyle.mainContent.copyWith(
              color: colorId < 3 ? Colors.black : Colors.white,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.0),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('Notes')
                    .doc(doc.id)
                    .delete();
              },
            ),
          ),
        ],
      ),
    ),
  );
}
