import 'package:flutter/material.dart';

class JournalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Add your note-adding functionality here
          },
          child: Text('Add Note'),
        ),
      ),
    );
  }
}
