import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_events/core/model/event.model.dart';

import '../../../core/service/user.service.dart';

class EventChatPage extends StatelessWidget {
  final Event event;
  final double? modalHeight;

  const EventChatPage({Key? key, required this.event, this.modalHeight})
      : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   final TextEditingController messageText = TextEditingController();
  //
  //   return Dialog(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(20.0),
  //     ),
  //     child: Container(
  //       height: modalHeight,
  //       padding: EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           AppBar(
  //             title: Text('${event.name} Chat'),
  //             automaticallyImplyLeading: false,
  //           ),
  //           Expanded(
  //             child: StreamBuilder<QuerySnapshot>(
  //               stream: FirebaseFirestore.instance
  //                   .collection('event_chats')
  //                   .doc(event.id)
  //                   .collection('messages')
  //                   .orderBy('timestamp', descending: true)
  //                   .snapshots(),
  //               builder: (context, snapshot) {
  //                 if (snapshot.connectionState == ConnectionState.waiting) {
  //                   return Center(
  //                     child: CircularProgressIndicator(),
  //                   );
  //                 }
  //
  //                 List<QueryDocumentSnapshot> messages =
  //                     snapshot.data?.docs ?? [];
  //
  //                 return ListView.builder(
  //                   reverse: true,
  //                   itemCount: messages.length,
  //                   itemBuilder: (context, index) {
  //                     Map<String, dynamic> messageData =
  //                         messages[index].data() as Map<String, dynamic>;
  //                     String userId = messageData['userId'];
  //                     String messageText = messageData['message'];
  //                     bool isCurrentUser =
  //                         FirebaseAuth.instance.currentUser?.uid == userId;
  //
  //                     return ListTile(
  //                       title: Card(
  //                         color: isCurrentUser ? Colors.teal : Colors.grey,
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Text(
  //                             messageText,
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       tileColor: Colors.transparent,
  //                       contentPadding: EdgeInsets.symmetric(
  //                           horizontal: 16.0, vertical: 8.0),
  //                       leading: isCurrentUser
  //                           ? null
  //                           : CircleAvatar(
  //                               child: Text(userId[0]),
  //                             ),
  //                       trailing: isCurrentUser
  //                           ? CircleAvatar(
  //                               child: Text(userId[0]),
  //                             )
  //                           : null,
  //                     );
  //                   },
  //                 );
  //               },
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: TextFormField(
  //                     controller: messageText,
  //                     decoration: InputDecoration(
  //                       hintText: 'Type your message...',
  //                       hintStyle: TextStyle(color: Colors.black54),
  //                     ),
  //                     style: TextStyle(color: Colors.black),
  //                     onFieldSubmitted: (message) {
  //                       _sendMessage(message);
  //                       messageText.clear();
  //                     },
  //                   ),
  //                 ),
  //                 IconButton(
  //                   icon: Icon(Icons.send),
  //                   onPressed: () {
  //                     _sendMessage(messageText.text);
  //                     messageText.clear();
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageText = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: modalHeight,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            AppBar(
              title: Text('${event.name} Chat'),
              automaticallyImplyLeading: false,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('event_chats')
                    .doc(event.id)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<QueryDocumentSnapshot> messages =
                      snapshot.data?.docs ?? [];

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageTile(context, messages[index]);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageText,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                      style: TextStyle(color: Colors.black),
                      onFieldSubmitted: (message) {
                        _sendMessage(message);
                        messageText.clear();
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _sendMessage(messageText.text);
                      messageText.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTile(BuildContext context, QueryDocumentSnapshot message) {
    Map<String, dynamic> messageData = message.data() as Map<String, dynamic>;
    String userId = messageData['userId'];
    String messageText = messageData['message'];
    bool isCurrentUser = FirebaseAuth.instance.currentUser?.uid == userId;

    return FutureBuilder<Map<String, dynamic>>(
      future: UserService().getUserInfoById(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        }

        Map<String, dynamic> userInfo = snapshot.data ?? {};
        String firstName = userInfo['firstName'] ?? '';

        return ListTile(
          title: Row(
            mainAxisAlignment: isCurrentUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Card(
                color: isCurrentUser ? Colors.teal : Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    messageText,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          tileColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          leading: isCurrentUser
              ? null
              : CircleAvatar(
            child: Text(firstName.isNotEmpty ? firstName : '',style: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),),
          ),
          trailing: isCurrentUser
              ? CircleAvatar(
            child: Text(firstName.isNotEmpty ? firstName : '',style: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),),
          )
              : null,
        );
      },
    );
  }



  void _sendMessage(String message) {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    FirebaseFirestore.instance
        .collection('event_chats')
        .doc(event.id)
        .collection('messages')
        .add({
      'userId': userId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
