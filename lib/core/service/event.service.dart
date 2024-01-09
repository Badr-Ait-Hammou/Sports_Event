import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sport_events/toasts/toast_notifications.dart';
import 'package:toastification/toastification.dart';

import '../model/event.model.dart';

class EventService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> deleteEvent(BuildContext context,String id) async {
    try {
      await firebaseFirestore.collection("events").doc(id).delete();
      ToastUtils.showErrorToast(context, "Done", "event Deleted Successfully");
    } catch (error) {
      print("Error deleting: $error");
    }
  }

  Future<List<DocumentSnapshot>> fetchDataFromFirebase() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('events').get();
    return querySnapshot.docs;
  }

  Stream<List<Event>> getEventsStreamForUser() {
    User? user = auth.currentUser;
    String userId = user?.uid ?? '';

    return firebaseFirestore
        .collection("users")
        .doc(userId)
        .snapshots()
        .asyncMap((userSnapshot) async {
      if (userSnapshot.exists) {
        List<String> userEventIds =
            List<String>.from(userSnapshot.get('events') ?? []);

        List<Event> joinedEvents = await firebaseFirestore
            .collection("events")
            .where(FieldPath.documentId, whereIn: userEventIds)
            .get()
            .then((eventsSnapshot) => eventsSnapshot.docs
                .map((doc) => Event.fromFirestore(doc))
                .toList());

        List<Event> createdEvents = await firebaseFirestore
            .collection("events")
            .where('createdBy', isEqualTo: userId)
            .get()
            .then((eventsSnapshot) => eventsSnapshot.docs
                .map((doc) => Event.fromFirestore(doc))
                .toList());

        return [...joinedEvents, ...createdEvents];
      } else {
        return [];
      }
    });
  }

  Future<void> joinEvent(BuildContext context,String eventId) async {
    try {
      User? user = auth.currentUser;
      String userId = user?.uid ?? '';

      DocumentSnapshot eventSnapshot =
          await firebaseFirestore.collection("events").doc(eventId).get();

      if (eventSnapshot.exists) {
        List<String> listParticipants = List<String>.from((eventSnapshot.data()
                as Map<String, dynamic>)['listParticipants'] ??
            []);

        listParticipants.add(userId);
        await firebaseFirestore
            .collection("events")
            .doc(eventId)
            .update({'listParticipants': listParticipants});

        await firebaseFirestore.collection("users").doc(userId).update({
          'events': FieldValue.arrayUnion([eventId]),
        });
        ToastUtils.showSuccessToast(context, "Done", "You Joined The Event Successfully");
      } else {
        print("Event not found");
      }
    } catch (error) {
      print("Error joining event: $error");
    }
  }

  Future<void> unjoinEvent(BuildContext context,String eventId) async {
    try {
      User? user = auth.currentUser;
      String userId = user?.uid ?? '';

      DocumentSnapshot eventSnapshot =
          await firebaseFirestore.collection("events").doc(eventId).get();

      if (eventSnapshot.exists) {
        List<String> listParticipants = List<String>.from((eventSnapshot.data()
                as Map<String, dynamic>)['listParticipants'] ??
            []);

        listParticipants.remove(userId);

        await firebaseFirestore
            .collection("events")
            .doc(eventId)
            .update({'listParticipants': listParticipants});

        await firebaseFirestore.collection("users").doc(userId).update({
          'events': FieldValue.arrayRemove([eventId]),
        });
        ToastUtils.showErrorToast(context, "Done", "You Enjoined The Event Successfully");

      } else {
        print("Event not found");
      }
    } catch (error) {
      print("Error unjoining event: $error");
    }
  }
}
