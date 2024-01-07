import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sport_events/core/utils/size_utils.dart';
import '../../components/custom_elevated_button.dart';
import 'package:path/path.dart' as path;

class AddEventScreen extends StatefulWidget {
  final double? modalHeight;
  AddEventScreen({Key? key, this.modalHeight}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  TextEditingController eventTypeController = TextEditingController();
  TextEditingController eventRuleController = TextEditingController();
  TextEditingController eventParticipantsController = TextEditingController();
  TextEditingController photoUrlController = TextEditingController();

  bool get wantKeepAlive => true;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  String imageUrl = '';
  bool img = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  Future<void> ajouteImage() async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final imageExtension = path.extension(image.path).toLowerCase();

        if (imageExtension == '.png' ||
            imageExtension == '.jpeg' ||
            imageExtension == '.jpg') {
          setState(() {
            imageUrl = image.path;
            img = true;
          });
        } else {
          print(
              "Échec de la mise à jour de l'image, essayez avec une autre image");

          Fluttertoast.showToast(
              msg:
                  "Échec de la mise à jour de l'image, essayez avec une autre image",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        print("Le fichier n'est pas une image");

        Fluttertoast.showToast(
            msg: "Le fichier n'est pas une image",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print("Error selecting image: $e");
      // Add any specific error handling here
    }
  }

  Future<void> addEvent(BuildContext context) async {
    try {
      User? user = auth.currentUser;
      String currentUserId = user?.uid ?? '';
      final storageRef = FirebaseStorage.instance.ref();
      File imageFile = File(imageUrl!);
      String imageName = path.basename(imageFile.path);
      Reference storageReference = storageRef.child('images/$imageName');
      print("currentUserId===> $currentUserId");
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() async {
        String downloadUrl = await storageReference.getDownloadURL();
        await _firestore.collection('events').add({
          'date': eventDateController.text,
          'name': eventNameController.text,
          'type': eventTypeController.text,
          'location': eventLocationController.text,
          'participant': eventParticipantsController.text,
          'listParticipants': [],
          'rule': eventRuleController.text,
          'photoUrl': downloadUrl,
          'createdBy': currentUserId,
        });

        Navigator.pop(context);

        Fluttertoast.showToast(
          msg: "Event added successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } catch (e) {
      print('Error adding event: $e');
      Fluttertoast.showToast(
        msg: "Error adding event",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: eventNameController,
              decoration: const InputDecoration(labelText: 'Event Name'),
            ),
            TextField(
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  eventDateController.text = _dateFormat.format(pickedDate);
                }
              },
              controller: eventDateController,
              decoration: const InputDecoration(labelText: 'Event Date'),
            ),
            TextFormField(
              controller: eventLocationController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              controller: eventTypeController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(labelText: 'Type'),
            ),
            TextFormField(
              controller: eventParticipantsController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(labelText: 'participants'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: eventRuleController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(labelText: 'rule'),
            ),
            Container(
              height: 50,
              width: 50,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
            IconButton(
              onPressed: ajouteImage,
              icon: Icon(Icons.camera_alt),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
                onPressed: () async {
                  await addEvent(context);
                },
                text: "Create Event",
                margin: EdgeInsets.only(left: 24.h, right: 24.h, bottom: 49.v))
          ],
        ),
      ),
    );
  }
}
