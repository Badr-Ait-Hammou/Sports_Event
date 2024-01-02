import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventCreationForm extends StatefulWidget {
  @override
  _EventCreationFormState createState() => _EventCreationFormState();
}

class _EventCreationFormState extends State<EventCreationForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _sportTypeController = TextEditingController();
  final TextEditingController _participantsController = TextEditingController();
  final TextEditingController _rulesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Event Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Event Date'),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Event Time'),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Event Location'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _sportTypeController,
              decoration: InputDecoration(labelText: 'Sport Type'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _participantsController,
              decoration: InputDecoration(labelText: 'Number of Participants'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _rulesController,
              decoration: InputDecoration(labelText: 'Event Rules'),
              maxLines: 3,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                _saveEvent();
              },
              child: Text('Save Event'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveEvent() {
    // Validate form fields
    if (_nameController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _sportTypeController.text.isEmpty ||
        _participantsController.text.isEmpty ||
        _rulesController.text.isEmpty) {
      // Show an error message or handle validation as needed
      return;
    }

    // Save event to Firestore
    FirebaseFirestore.instance.collection('events').add({
      'name': _nameController.text,
      'date': _dateController.text,
      'time': _timeController.text,
      'location': _locationController.text,
      'sportType': _sportTypeController.text,
      'participants': int.parse(_participantsController.text),
      'rules': _rulesController.text,
      // Add other event attributes here
    }).then((value) {
      // Handle success, e.g., navigate back to the events list
      Navigator.pop(context);
    }).catchError((error) {
      // Handle error, e.g., show an error message
      print('Error saving event: $error');
    });
  }
}
