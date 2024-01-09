import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sport_events/components/app_icons.dart';
import 'package:sport_events/components/custom_outlined_button.dart';
import 'package:sport_events/core/utils/size_utils.dart';
import 'package:sport_events/toasts/toast_notifications.dart';
import '../../components/custom_elevated_button.dart';
import 'package:path/path.dart' as path;

import '../../components/custom_image_view.dart';
import '../../core/utils/image_constant.dart';

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
  TextEditingController eventDescriptionController = TextEditingController();
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
          ToastUtils.showSuccessToast(context, "Done", "Image Uploaded Successfully");

        } else {
          ToastUtils.showErrorToast(context, "Error", "oops! error adding image ");
        }
        } else {
        print("Le fichier n'est pas une image");

        ToastUtils.showErrorToast(context, "Error", "oops! The selected file isn't an image ");
      }
    } catch (e) {
      print("Error selecting image: $e");
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
          'description': eventDescriptionController.text,
          'location': eventLocationController.text,
          'participant': eventParticipantsController.text,
          'listParticipants': [],
          'rule': eventRuleController.text,
          'photoUrl': downloadUrl,
          'createdBy': currentUserId,
        });

        Navigator.pop(context);

       ToastUtils.showSuccessToast(context, "Done", "Event Added Successfully");
      });
    } catch (e) {
      print('Error adding event: $e');
      ToastUtils.showErrorToast(context, "Error", "oops! something went wrong");

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
              style: TextStyle(color: Colors.black),
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
              style: TextStyle(color: Colors.black),
              decoration: const InputDecoration(labelText: 'Event Date'),
            ),
            TextFormField(
              controller: eventLocationController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              controller: eventDescriptionController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(labelText: 'Description'),
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
                  : null,
            ),
            // IconButton(
            //   onPressed: ajouteImage,
            //   icon: Icon(Icons.camera_alt),
            // ),
            CustomOutlinedButton(
                  onPressed: ajouteImage,
                leftIcon: Container(
                  margin: EdgeInsets.only(right: 20.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgGrid,
                    height: 28.adaptSize,
                    width: 28.adaptSize,
                  ),

                ),
                text: "Select image",
                margin: EdgeInsets.only(left: 24.h, right: 24.h, bottom: 5.v)
            ),
            const SizedBox(
              height: 5,
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
