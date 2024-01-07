import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String date;
  String name;
  String type;
  String location;
  String participant;
  List<String> listParticipants;
  String rule;
  String photoUrl;
  String createdBy;

  Event({
    required this.id,
    required this.date,
    required this.name,
    required this.type,
    required this.location,
    required this.participant,
    required this.listParticipants,
    required this.rule,
    required this.photoUrl,
    required this.createdBy,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Event(
      id: doc.id,
      date: data['date'] ?? '',
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      location: data['location'] ?? '',
      participant: data['participant'] ?? '',
      listParticipants: List<String>.from(data['listParticipants'] ?? []),
      rule: data['rule'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      createdBy: data['createdBy'] ?? '',
    );
  }
}
