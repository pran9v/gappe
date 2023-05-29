import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom extends StatefulWidget {
  final String username;

  const ChatRoom({Key? key, required this.username}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  DateTime? backButtonPressedTime;
  final TextEditingController _textEditingController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // map of colors for each user
  final Map<String, Color> _userColorMap = {};

  // list of colors
  final _colorList = [
    Colors.red,
    //Colors.black,
    Colors.blue,
    Colors.purple,
    Colors.teal,
  ];

  // Returns the color for the given username, assigning colors in a round-robin manner
  Color _getColorForUsername(String username) {
    if (_userColorMap.containsKey(username)) {
      return _userColorMap[username]!;
    } else {
      final colorIndex = _userColorMap.length % _colorList.length;
      final color = _colorList[colorIndex];
      _userColorMap[username] = color;
      return color;
    }
  }

  void _sendMessage(String message) async {
    if (message.isNotEmpty) {
      await _firestore.collection('messages').add({
        'username': widget.username,
        'message': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      _textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime currentTime = DateTime.now();

        // Allow back button to close the app if pressed twice within 2 seconds
        if (backButtonPressedTime == null ||
            currentTime.difference(backButtonPressedTime!) >
                const Duration(seconds: 2)) {
          backButtonPressedTime = currentTime;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Press back again to exit')),
          );
          return false;
        }
        exit(0);

      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFADA9D),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.amber,
          centerTitle: true,
          title: const Text('Chat Room', style: TextStyle(color: Colors.black)),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('messages')
                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      final messages = snapshot.data!.docs.reversed;
                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final bool isSentByCurrentUser =
                              messages.elementAt(index)['username'] ==
                                  widget.username;

                          // get the color for the current message's username
                          final color = _getColorForUsername(
                              messages.elementAt(index)['username']);

                          // get the timestamp of the message
                          final timestamp =
                              messages.elementAt(index)['timestamp'] as int;
                          final messageTime =
                              DateTime.fromMillisecondsSinceEpoch(timestamp);
                          // changing the format as HH:mm:ss
                          final formattedTime =
                              DateFormat.jms().format(messageTime);

                          if (isSentByCurrentUser) {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 14),
                                margin: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 50, right: 10),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    bottomLeft: Radius.circular(18),
                                    bottomRight: Radius.circular(18),
                                  ),
                                  color: Colors.amber,
                                ),
                                // displaying the username and the time at which the message was sent
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          messages.elementAt(index)['username'],
                                          style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          formattedTime,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    // displaying the message
                                    Text(
                                      messages.elementAt(index)['message'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 14),
                                margin: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 50),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(18),
                                      bottomLeft: Radius.circular(18),
                                      bottomRight: Radius.circular(18)),
                                  color: Colors.white70,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          messages.elementAt(index)['username'],
                                          style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          formattedTime,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      messages.elementAt(index)['message'],
                                      style: TextStyle(
                                        color: isSentByCurrentUser
                                            ? Colors.black
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Scrollbar(
                    child: TextField(
                      autocorrect: false,
                      maxLines: 5,
                      minLines: 1,
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        fillColor: Colors.black,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send, color: Colors.amber),
                          onPressed: () =>
                              _sendMessage(_textEditingController.text),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                            top: 14.0, left: 15.0, right: 15.0, bottom: 5.0),
                        hintText: "Type your message",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
