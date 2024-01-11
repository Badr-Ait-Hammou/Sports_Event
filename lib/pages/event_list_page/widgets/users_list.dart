import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sport_events/core/model/event.model.dart';
import 'package:sport_events/core/service/firebase.service.dart';

class ManageUsers extends StatelessWidget {
  final Event event;
  final double? modalHeight;

  const ManageUsers({Key? key, required this.event, this.modalHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: modalHeight,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              title: Text('Manage ${event.name} users'),
              automaticallyImplyLeading: false,
            ),
            SizedBox(height: 16.0),
            Text(
              'Participating Users:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .doc(event.id!)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('Event not found.');
                  }

                  List<dynamic> participantIds =
                      snapshot.data!.get('listParticipants') ?? [];

                  return ListView.builder(
                    itemCount: participantIds.length,
                    itemBuilder: (context, index) {
                      String userId = participantIds[index];

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox.shrink();
                          }

                          if (!userSnapshot.hasData ||
                              !userSnapshot.data!.exists) {
                            return SizedBox.shrink();
                          }

                          bool isParticipant = participantIds.contains(userId);

                          return ListTile(
                            title: Text(userSnapshot.data!.get('email')),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check),
                                  color: isParticipant
                                      ? Colors.green
                                      : Colors.grey,
                                  onPressed: () {
                                    _updateParticipantStatus(
                                      userId,
                                      !isParticipant,
                                      event.id!,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  color: Colors.red,
                                  onPressed: () {
                                    _updateParticipantStatus(
                                      userId,
                                      false,
                                      event.id!,
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
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

  void _updateParticipantStatus(
      String userId, bool addParticipant, String eventId) {
    CollectionReference eventRef =
        FirebaseFirestore.instance.collection('events');

    eventRef.doc(eventId).update({
      'listParticipants': addParticipant
          ? FieldValue.arrayUnion([userId])
          : FieldValue.arrayRemove([userId]),
    }).then((_) {
      print('Participant updated successfully!');
      _sendNotification(userId, event.name, addParticipant);
    }).catchError((error) {
      print('Error updating participant: $error');
    });
  }

  void _sendNotification(String userId, String eventName, bool isJoining) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((userSnapshot) {
      if (userSnapshot != null && userSnapshot.exists) {
        String? fcmToken = userSnapshot.get('tokenId');
        if (fcmToken != null && fcmToken.isNotEmpty) {
          FirebaseMessaging.instance.sendMessage(
            to: fcmToken,
            data: {
              'event_name': eventName,
              'is_joining': isJoining.toString(),
            },
          );
        }
      }
    }).catchError((error) {
      print('Error getting FCM token: $error');
    });
  }
}
