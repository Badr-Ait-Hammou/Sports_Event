import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sport_events/core/utils/size_utils.dart';
import '../../components/app_bar/appbar_leading_image.dart';
import '../../components/app_bar/appbar_title.dart';
import '../../components/app_bar/appbar_trailing_image.dart';
import '../../components/app_bar/custom_app_bar.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_image_view.dart';
import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import 'package:path/path.dart' as path;





class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

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


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        height: 50.v,
        leadingWidth: 56.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.logo,
            margin: EdgeInsets.only(left: 24.h, top: 9.v, bottom: 9.v)),
        title: AppbarTitle(text: "Home", margin: EdgeInsets.only(left: 16.h)),
        actions: [
          AppbarTrailingImage(
              imagePath: ImageConstant.imgIcons,
              margin: EdgeInsets.only(left: 24.h, top: 11.v, right: 11.h),
              onTap: () {
                // onTapIcons(context);
              }),
          AppbarTrailingImage(
              imagePath: ImageConstant.imgClock,
              margin: EdgeInsets.only(left: 20.h, top: 11.v, right: 35.h))
        ],
      ),
      body: SizedBox(
        width: mediaQueryData.size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30.v),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(left: 24.h),
                  child: Column(
                    children: [
                      //_buildHotelsList(context),
                      SizedBox(height: 34.v),
                      _buildRecentlyBookedList(context)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDemandeModal(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildRecentlyBookedList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 24.h),
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('events').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator(); // Loading indicator
              }

              List<QueryDocumentSnapshot> demandes = snapshot.data!.docs;

              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 24.v);
                },
                itemCount: demandes.length,
                itemBuilder: (context, index) {
                  return _buildDemandeItem(context, demandes[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDemandeItem(BuildContext context, QueryDocumentSnapshot demande) {
    String name = demande['name'] ?? '';
    String date = demande['date'] ?? '';
    String location = demande['location'] ?? '';
    String type = demande['type'] ?? '';
    String rule = demande['rule'] ?? '';
    String participant = demande['participant'] ?? '';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.v, horizontal: 18.v),
      decoration: AppDecoration.outlineBlackC.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 11.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " $date ",
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(height: 18.v),
                Text(
                  "city :$location",
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: 12.v),
                Row(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgCalendar,
                      height: 12.adaptSize,
                      width: 12.adaptSize,
                      margin: EdgeInsets.symmetric(vertical: 2.v),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.h),
                      child: Text(
                        "Vehicle: $type",
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8.h,
                        top: 1.v,
                      ),
                      child: Text(
                        "$rule",
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10.v,
              bottom: 8.v,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$participant participant",
                  style: CustomTextStyles.headlineSmallPrimary,
                ),
                SizedBox(height: 2.v),
                Text(
                  "",
                  style: theme.textTheme.labelMedium,
                ),
                SizedBox(height: 16.v),
                Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.teal,
                    ),
                    onPressed: () {
                      _deleteDemande(demande);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
  void _deleteDemande(QueryDocumentSnapshot event) async {
    await _firestore.collection('events').doc(event.id).delete();
  }

  onTapTxtSeeAll(BuildContext context) {}

  // void _showAddDemandeModal(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return _buildAddDemandeForm(context);
  //     },
  //   );
  // }


  void _showAddDemandeModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
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
                    if (imageUrl.isNotEmpty) {
                      try {
                        final storageRef = FirebaseStorage.instance.ref();
                        File imageFile = File(imageUrl!);
                        String imageName = path.basename(imageFile.path);
                        Reference storageReference =
                        storageRef.child('images/$imageName');


                        UploadTask uploadTask =
                        storageReference.putFile(imageFile);
                        await uploadTask.whenComplete(() async {
                          String downloadUrl =
                          await storageReference.getDownloadURL();
                          print("Download URL: $downloadUrl");

                          await _firestore.collection('events').add({
                            'date': eventDateController.text,
                            'name': eventNameController.text,
                            'type': eventTypeController.text,
                            'location': eventLocationController.text,
                            'participant': eventParticipantsController.text,
                            'rule': eventRuleController.text,
                            'photoUrl': downloadUrl,
                          });

                          eventNameController.clear();
                          eventDateController.clear();
                          imageUrl = '';
                          img = false;

                          Navigator.of(context).pop();

                          Fluttertoast.showToast(
                              msg: "Event added successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.greenAccent,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        });
                      } catch (e) {
                        print("Error uploading image to Firebase Storage: $e");
                        Fluttertoast.showToast(
                            msg: "Error uploading image to Firebase Storage",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please select an image for the event",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                    text: "Create Event",
                    margin: EdgeInsets.only(left: 24.h, right: 24.h, bottom: 49.v)
                )
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildAddDemandeForm(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: eventNameController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(labelText: 'name'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
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
                decoration: InputDecoration(labelText: 'Date '),
              ),
              // TextFormField(
              //   readOnly: true,
              //   onTap: () async {
              //     DateTime? pickedDate = await showDatePicker(
              //       context: context,
              //       initialDate: DateTime.now(),
              //       firstDate: DateTime(2000),
              //       lastDate: DateTime(2101),
              //     );
              //     if (pickedDate != null) {
              //       dateEndController.text = _dateFormat.format(pickedDate);
              //     }
              //   },
              //   controller: dateEndController,
              //   style: TextStyle(color: Colors.black),
              //   decoration: InputDecoration(labelText: 'Date End'),
              // ),

              TextFormField(
                controller: eventLocationController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(labelText: 'City'),
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
              IconButton(
                onPressed: ajouteImage,
                icon: Icon(Icons.camera_alt),
              ),
              SizedBox(height: 16.0),
              Center(
                child: CustomElevatedButton(
                  height: 38.v,
                  text: "Save ",
                  margin: EdgeInsets.only(left: 6.h),
                  buttonStyle: CustomButtonStyles.fillPrimaryTL19,
                  buttonTextStyle: CustomTextStyles.titleMediumSemiBold,
                  onPressed: () {
                    _addEventToFirestore(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _addEventToFirestore(BuildContext context) async {
    try {
      await _firestore.collection('events').add({
        'date': eventDateController.text,
        'name': eventNameController.text,
        'type': eventTypeController.text,
        'location': eventLocationController.text,
        'participant': eventParticipantsController.text,
        'rule': eventRuleController.text,
        'photoUrl': imageUrl, // Save the photoUrl
      });
      Navigator.pop(context);
    } catch (e) {
      print('Error adding demande: $e');
    }
  }
}



//   TextEditingController eventNameController = TextEditingController();
//   TextEditingController eventDateController = TextEditingController();
//   TextEditingController eventLocationController = TextEditingController();
//   TextEditingController eventTypeController = TextEditingController();
//   TextEditingController eventRuleController = TextEditingController();
//   TextEditingController eventParticipantsController = TextEditingController();
//
//   void _saveEvent() {
//     if (_formKey.currentState?.validate() ?? false) {
//       try {
//         int participants = int.parse(eventParticipantsController.text);
//
//         FirebaseFirestore.instance.collection('events').add({
//           'name': eventNameController.text,
//           'date': eventDateController.text,
//           'location': eventLocationController.text,
//           'sportType': eventTypeController.text,
//           'participants': participants,
//           'rules': eventRuleController.text,
//         }).then((value) {
//           _showSnackbar("Event saved successfully");
//           _clearInputs();
//         }).catchError((error) {
//           _showSnackbar("Error saving event: $error");
//         });
//       } catch (e) {
//         _showSnackbar("Invalid number of participants");
//       }
//     }
//   }
//   void _clearInputs() {
//     eventNameController.clear();
//     eventDateController.clear();
//     eventLocationController.clear();
//     eventTypeController.clear();
//     eventParticipantsController.clear();
//     eventRuleController.clear();
//   }
//
//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
//
//
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     mediaQueryData = MediaQuery.of(context);
//     return  Scaffold(
//             resizeToAvoidBottomInset: false,
//         appBar: CustomAppBar(
//             height: 50.v,
//             leadingWidth: 56.h,
//             leading: AppbarLeadingImage(
//                 imagePath: ImageConstant.logo,
//                 margin: EdgeInsets.only(left: 24.h, top: 9.v, bottom: 9.v)),
//             title:
//             AppbarTitle(text: "Add Event", margin: EdgeInsets.only(left: 16.h)),
//             actions: [
//               AppbarTrailingImage(
//                   imagePath: ImageConstant.imgIcons,
//                   margin: EdgeInsets.only(left: 24.h, top: 11.v, right: 11.h),
//                  ),
//               AppbarTrailingImage(
//                   imagePath: ImageConstant.imgClock,
//                   margin: EdgeInsets.only(left: 20.h, top: 11.v, right: 35.h))
//             ]),
//     body: SingleChildScrollView(
//     child: Form(
//                 key: _formKey,
//                 child: Container(
//                     width: double.maxFinite,
//                     padding:
//                     EdgeInsets.symmetric(horizontal: 24.h, vertical: 43.v),
//                     child: Column(children: [
//                       _buildEditProfileLabel1(context),
//                       SizedBox(height: 24.v),
//                       _buildEditProfileLabel2(context),
//                       SizedBox(height: 24.v),
//                       _buildEditProfileDate(context),
//                       SizedBox(height: 24.v),
//                       _buildEventType(context),
//                       SizedBox(height: 24.v),
//                       _buildEventParticipant(context),
//                       SizedBox(height: 24.v),
//                       _buildEventRules(context),
//                       SizedBox(height: 24.v),
//                     ]))
//             )),
//             bottomNavigationBar: _buildUpdateButton(context));
//   }
//
//
//   /// Section Widget
//   Widget _buildEditProfileLabel1(BuildContext context) {
//     return CustomTextFormField(
//         controller: eventNameController, hintText: "Name");
//   }
//
//   /// Section Widget
//   Widget _buildEditProfileLabel2(BuildContext context) {
//     return CustomTextFormField(
//         controller: eventLocationController, hintText: "Location");
//   }
//
//   /// Section Widget
//   Widget _buildEditProfileDate(BuildContext context) {
//     return CustomTextFormField(
//         controller: eventDateController,
//         hintText: "12/27/1995",
//         suffix: Container(
//             margin: EdgeInsets.fromLTRB(30.h, 18.v, 20.h, 18.v),
//             child: CustomImageView(
//                 imagePath: ImageConstant.imgIconlyCurvedCalendarPrimary,
//                 height: 20.adaptSize,
//                 width: 20.adaptSize)),
//         suffixConstraints: BoxConstraints(maxHeight: 56.v),
//         contentPadding: EdgeInsets.only(left: 20.h, top: 19.v, bottom: 19.v));
//   }
//
//   Widget _buildEventType(BuildContext context) {
//     return CustomTextFormField(
//         controller: eventTypeController,
//         hintText: "12/27/1995",
//         suffix: Container(
//             margin: EdgeInsets.fromLTRB(30.h, 18.v, 20.h, 18.v),
//             child: CustomImageView(
//                 imagePath: ImageConstant.imgIconlyCurvedCalendarPrimary,
//                 height: 20.adaptSize,
//                 width: 20.adaptSize)),
//         suffixConstraints: BoxConstraints(maxHeight: 56.v),
//         contentPadding: EdgeInsets.only(left: 20.h, top: 19.v, bottom: 19.v));
//   }
//
//  Widget _buildEventParticipant(BuildContext context) {
//     return CustomTextFormField(
//         controller: eventParticipantsController,
//         hintText: "Participants",
//         suffix: Container(
//             margin: EdgeInsets.fromLTRB(30.h, 18.v, 20.h, 18.v),
//             child: CustomImageView(
//                 imagePath: ImageConstant.imgIconlyCurvedCalendarPrimary,
//                 height: 20.adaptSize,
//                 width: 20.adaptSize)),
//         suffixConstraints: BoxConstraints(maxHeight: 56.v),
//         contentPadding: EdgeInsets.only(left: 20.h, top: 19.v, bottom: 19.v));
//   }
//
//
//   /// Section Widget
//   Widget _buildEventRules(BuildContext context) {
//     return CustomTextFormField(
//         controller: eventRuleController,
//         hintText: "Rules",
//         textInputAction: TextInputAction.done,
//         prefix: Padding(
//             padding: EdgeInsets.fromLTRB(20.h, 19.v, 30.h, 19.v),
//             child: Row(mainAxisSize: MainAxisSize.min, children: [
//               CustomImageView(
//                   imagePath: ImageConstant.imageNotFound,
//                   height: 18.v,
//                   width: 24.h,
//                   margin: EdgeInsets.fromLTRB(20.h, 19.v, 30.h, 19.v)),
//               CustomImageView(
//                   imagePath: ImageConstant.imageNotFound,
//                   height: 4.67.v,
//                   width: 9.33.h)
//             ])),
//         prefixConstraints: BoxConstraints(maxHeight: 56.v),
//         contentPadding: EdgeInsets.only(top: 19.v, right: 30.h, bottom: 19.v));
//   }
//
//   /// Section Widget
//   Widget _buildUpdateButton(BuildContext context) {
//     return CustomElevatedButton(
//         onPressed: () {
//           _saveEvent();
//         },
//         text: "Create Event",
//         margin: EdgeInsets.only(left: 24.h, right: 24.h, bottom: 49.v));
//   }
//
//   /// Navigates back to the previous screen.
//   onTapArrowLeft(BuildContext context) {
//     Navigator.pop(context);
//   }
// }