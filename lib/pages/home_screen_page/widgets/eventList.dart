
import 'package:flutter/material.dart';

import '../../../model/event.dart';
class EventListItem extends StatelessWidget {
  final Map<String, dynamic> event;

  EventListItem({required this.event});
  @override
  Widget build(BuildContext context) {
    Event eventObject = Event(
      name: event['name'],
      date: event['date'],
      time: event['time'],
      location: event['location'],
      sportType: event['sportType'],
      participants: event['participants'],
      rules: event['rules'],
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Display event details using CustomImageView or other widgets
          // Add your widgets based on the design of an event item
          // For simplicity, I'll display the event name and date here
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name: ${eventObject.name}",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text("Date: ${eventObject.date}"),
            ],
          ),
          // Add other details as needed
        ],
      ),
    );
  }
}
