import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String date;
  String name;
  String type;
  String location;
  List<String> participants;
  String rule;
  String photoUrl;
  String createdBy;

  Event({
    required this.id,
    required this.date,
    required this.name,
    required this.type,
    required this.location,
    required this.participants,
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
      participants: List<String>.from(data['participants'] ?? []),
      rule: data['rule'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      createdBy: data['createdBy'] ?? '',
    );
  }
}
