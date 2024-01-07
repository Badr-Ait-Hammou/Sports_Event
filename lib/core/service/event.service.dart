import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> deleteEvent(String id) async {
    try {
      await firebaseFirestore.collection("events").doc(id).delete();
    } catch (error) {
      print("Error deleting: $error");
    }
  }

  Future<void> joinEvent(String eventId) async {
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
        Fluttertoast.showToast(
            msg: "joined succ...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 103, 255, 77),
            textColor: Colors.black,
            fontSize: 16.0);
      } else {
        print("Event not found");
      }
    } catch (error) {
      print("Error joining event: $error");
    }
  }
}
