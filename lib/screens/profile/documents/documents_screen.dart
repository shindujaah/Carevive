import 'package:carevive/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class DocumentScreen extends StatefulWidget {
  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  bool _isUploading = false;
  String? _uploadStatus;

  Future<void> _pickAndUploadFile() async {
    // Request storage permission
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        setState(() {
          _uploadStatus = 'Storage permission not granted';
        });
        return;
      }
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _isUploading = true;
        _uploadStatus = null;
      });

      PlatformFile file = result.files.first;
      String fileName = file.name;
      String filePath = file.path!;
      File fileToUpload = File(filePath);

      try {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child('uploads/${_currentUser!.uid}/$fileName')
            .putFile(fileToUpload);

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        String storagePath = 'uploads/${_currentUser!.uid}/$fileName';

        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .collection('documents')
            .add({
          'fileName': fileName,
          'downloadUrl': downloadUrl,
          'storagePath': storagePath,
          'uploadedAt': Timestamp.now(),
        });

        setState(() {
          _isUploading = false;
          _uploadStatus = 'File uploaded successfully!';
        });
      } catch (e) {
        setState(() {
          _isUploading = false;
          _uploadStatus = 'Failed to upload file';
        });
      }
    }
  }

  Future<void> _deleteDocument(DocumentSnapshot document) async {
    if (_currentUser == null) return;

    String storagePath = document.get('storagePath');

    try {
      // Delete from Firebase Storage
      await FirebaseStorage.instance.ref(storagePath).delete();

      // Delete from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('documents')
          .doc(document.id)
          .delete();

      setState(() {
        _uploadStatus = 'Document deleted successfully';
      });
    } catch (e) {
      setState(() {
        _uploadStatus = 'Failed to delete document';
      });
    }
  }

  Widget _buildFilePreview(Map<String, dynamic> documentData) {
    String fileName = documentData['fileName'];
    String downloadUrl = documentData['downloadUrl'];

    bool isImage = fileName.endsWith('.jpg') ||
        fileName.endsWith('.jpeg') ||
        fileName.endsWith('.png');

    bool isPDF = fileName.endsWith('.pdf');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isImage)
          Image.network(
            downloadUrl,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          )
        else if (isPDF)
          Icon(
            Icons.picture_as_pdf,
            size: 40,
            color: Colors.redAccent,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Documents',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor1,
                foregroundColor: Colors.white,
              ),
              onPressed: _pickAndUploadFile,
              child: Text('Upload Document'),
            ),
            SizedBox(height: 20),
            if (_isUploading) CircularProgressIndicator(),
            if (_uploadStatus != null) Text(_uploadStatus!),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(_currentUser!.uid)
                    .collection('documents')
                    .orderBy('uploadedAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<DocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> documentData =
                          documents[index].data()! as Map<String, dynamic>;
                      String fileName = documentData['fileName'];
                      String downloadUrl = documentData['downloadUrl'];

                      return ListTile(
                        leading: _buildFilePreview(documentData),
                        title: Text(fileName),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                _showDeleteConfirmationDialog(documents[index]);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(DocumentSnapshot document) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Document'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this document?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteDocument(document);
              },
            ),
          ],
        );
      },
    );
  }
}
