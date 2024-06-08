import 'package:carevive/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:firebase_core/firebase_core.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _initFirebaseAuth();
  }

  Future<void> _initFirebaseAuth() async {
    await Firebase.initializeApp();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          _currentUser = user;
        });
        _loadMessages();
      } else {
        Navigator.pop(context);
      }
    });
  }

  Future<void> _loadMessages() async {
    if (_currentUser == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('messages')
        .orderBy('timestamp')
        .get();

    final List<Map<String, String>> loadedMessages = snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        data['sender'] as String: data['message'] as String,
      };
    }).toList();

    setState(() {
      _messages.addAll(loadedMessages);
    });

    _scrollToBottom();
  }

  Future<void> _sendMessage(String message) async {
    if (_currentUser == null) return;

    setState(() {
      _isLoading = true;
      _messages.add({'user': message});
      _messages.add({'bot': ''}); // Add a placeholder for the bot response
    });

    _scrollToBottom();

    final response = await _fetchChatbotResponse(message);

    setState(() {
      _isLoading = false;
      _messages[_messages.length - 1] = {
        'bot': response
      }; // Update the placeholder with the actual response
    });

    await _saveMessage('user', message);
    await _saveMessage('bot', response);

    _scrollToBottom();
  }

  Future<String> _fetchChatbotResponse(String query) async {
    final url = 'https://conversation.qwzhub.com/api/conversation';
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = {
      'query': query,
    };

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: body,
          )
          .timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['result'] ?? 'No response';
      } else {
        return 'Something Went Wrong, Try Again';
      }
    } catch (e) {
      return 'Something Went Wrong, Try Again';
    }
  }

  Future<void> _saveMessage(String sender, String message) async {
    if (_currentUser == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('messages')
        .add({
      'sender': sender,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _deleteAllMessages() async {
    if (_currentUser == null) return;

    final messages = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('messages')
        .get();

    for (var doc in messages.docs) {
      await doc.reference.delete();
    }

    setState(() {
      _messages.clear();
    });
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete All Conversation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete all conversation?'),
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
                _deleteAllMessages();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Chatbot',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              onPressed: _showDeleteConfirmationDialog,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _messages.isEmpty
              ? Expanded(
                  child: Center(
                      child: Text(
                  "Start Conversation",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )))
              : Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: message.containsKey('user')
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: message.containsKey('bot') &&
                                  message['bot']!.isEmpty &&
                                  _isLoading
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: LoadingAnimationWidget.waveDots(
                                    color: Colors.black54,
                                    size: 40,
                                  ),
                                )
                              : Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.8,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: message.containsKey('user')
                                        ? Colors.grey[300]
                                        : AppColors.primaryColor1,
                                    borderRadius: message.containsKey('user')
                                        ? BorderRadius.only(
                                            topLeft: Radius.circular(15.0),
                                            bottomLeft: Radius.circular(15.0),
                                            bottomRight: Radius.circular(15.0),
                                          )
                                        : BorderRadius.only(
                                            topRight: Radius.circular(15.0),
                                            bottomLeft: Radius.circular(15.0),
                                            bottomRight: Radius.circular(15.0),
                                          ),
                                  ),
                                  child: Text(
                                    message.values.first,
                                    style: TextStyle(
                                      color: message.containsKey('user')
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 5),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: AppColors.primaryColor1,
                  ),
                  onPressed: () {
                    final message = _controller.text.trim();
                    if (message.isNotEmpty) {
                      _controller.clear();
                      _sendMessage(message);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
