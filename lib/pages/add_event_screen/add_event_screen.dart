import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sport_events/core/utils/size_utils.dart';
import '../../components/app_bar/appbar_leading_image.dart';
import '../../components/app_bar/appbar_title.dart';
import '../../components/app_bar/appbar_trailing_image.dart';
import '../../components/app_bar/custom_app_bar.dart';
import '../../components/custom_drop_down.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_image_view.dart';
import '../../components/custom_text_form_field.dart';
import '../../core/utils/image_constant.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  TextEditingController eventTypeController = TextEditingController();
  TextEditingController eventRuleController = TextEditingController();
  TextEditingController eventParticipantsController = TextEditingController();

  void _saveEvent() {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        int participants = int.parse(eventParticipantsController.text);

        FirebaseFirestore.instance.collection('events').add({
          'name': eventNameController.text,
          'date': eventDateController.text,
          'location': eventLocationController.text,
          'sportType': eventTypeController.text,
          'participants': participants,
          'rules': eventRuleController.text,
        }).then((value) {
          _showSnackbar("Event saved successfully");
          _clearInputs();
        }).catchError((error) {
          _showSnackbar("Error saving event: $error");
        });
      } catch (e) {
        _showSnackbar("Invalid number of participants");
      }
    }
  }
  void _clearInputs() {
    eventNameController.clear();
    eventDateController.clear();
    eventLocationController.clear();
    eventTypeController.clear();
    eventParticipantsController.clear();
    eventRuleController.clear();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }


  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return  Scaffold(
            resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
            height: 50.v,
            leadingWidth: 56.h,
            leading: AppbarLeadingImage(
                imagePath: ImageConstant.logo,
                margin: EdgeInsets.only(left: 24.h, top: 9.v, bottom: 9.v)),
            title:
            AppbarTitle(text: "Add Event", margin: EdgeInsets.only(left: 16.h)),
            actions: [
              AppbarTrailingImage(
                  imagePath: ImageConstant.imgIcons,
                  margin: EdgeInsets.only(left: 24.h, top: 11.v, right: 11.h),
                 ),
              AppbarTrailingImage(
                  imagePath: ImageConstant.imgClock,
                  margin: EdgeInsets.only(left: 20.h, top: 11.v, right: 35.h))
            ]),
    body: SingleChildScrollView(
    child: Form(
                key: _formKey,
                child: Container(
                    width: double.maxFinite,
                    padding:
                    EdgeInsets.symmetric(horizontal: 24.h, vertical: 43.v),
                    child: Column(children: [
                      _buildEditProfileLabel1(context),
                      SizedBox(height: 24.v),
                      _buildEditProfileLabel2(context),
                      SizedBox(height: 24.v),
                      _buildEditProfileDate(context),
                      SizedBox(height: 24.v),
                      _buildEventType(context),
                      SizedBox(height: 24.v),
                      _buildEventParticipant(context),
                      SizedBox(height: 24.v),
                      _buildEventRules(context),
                      SizedBox(height: 24.v),
                    ]))
            )),
            bottomNavigationBar: _buildUpdateButton(context));
  }


  /// Section Widget
  Widget _buildEditProfileLabel1(BuildContext context) {
    return CustomTextFormField(
        controller: eventNameController, hintText: "Name");
  }

  /// Section Widget
  Widget _buildEditProfileLabel2(BuildContext context) {
    return CustomTextFormField(
        controller: eventLocationController, hintText: "Location");
  }

  /// Section Widget
  Widget _buildEditProfileDate(BuildContext context) {
    return CustomTextFormField(
        controller: eventDateController,
        hintText: "12/27/1995",
        suffix: Container(
            margin: EdgeInsets.fromLTRB(30.h, 18.v, 20.h, 18.v),
            child: CustomImageView(
                imagePath: ImageConstant.imgIconlyCurvedCalendarPrimary,
                height: 20.adaptSize,
                width: 20.adaptSize)),
        suffixConstraints: BoxConstraints(maxHeight: 56.v),
        contentPadding: EdgeInsets.only(left: 20.h, top: 19.v, bottom: 19.v));
  }

  Widget _buildEventType(BuildContext context) {
    return CustomTextFormField(
        controller: eventTypeController,
        hintText: "12/27/1995",
        suffix: Container(
            margin: EdgeInsets.fromLTRB(30.h, 18.v, 20.h, 18.v),
            child: CustomImageView(
                imagePath: ImageConstant.imgIconlyCurvedCalendarPrimary,
                height: 20.adaptSize,
                width: 20.adaptSize)),
        suffixConstraints: BoxConstraints(maxHeight: 56.v),
        contentPadding: EdgeInsets.only(left: 20.h, top: 19.v, bottom: 19.v));
  }

 Widget _buildEventParticipant(BuildContext context) {
    return CustomTextFormField(
        controller: eventParticipantsController,
        hintText: "Participants",
        suffix: Container(
            margin: EdgeInsets.fromLTRB(30.h, 18.v, 20.h, 18.v),
            child: CustomImageView(
                imagePath: ImageConstant.imgIconlyCurvedCalendarPrimary,
                height: 20.adaptSize,
                width: 20.adaptSize)),
        suffixConstraints: BoxConstraints(maxHeight: 56.v),
        contentPadding: EdgeInsets.only(left: 20.h, top: 19.v, bottom: 19.v));
  }


  /// Section Widget
  Widget _buildEventRules(BuildContext context) {
    return CustomTextFormField(
        controller: eventRuleController,
        hintText: "Rules",
        textInputAction: TextInputAction.done,
        prefix: Padding(
            padding: EdgeInsets.fromLTRB(20.h, 19.v, 30.h, 19.v),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              CustomImageView(
                  imagePath: ImageConstant.imageNotFound,
                  height: 18.v,
                  width: 24.h,
                  margin: EdgeInsets.fromLTRB(20.h, 19.v, 30.h, 19.v)),
              CustomImageView(
                  imagePath: ImageConstant.imageNotFound,
                  height: 4.67.v,
                  width: 9.33.h)
            ])),
        prefixConstraints: BoxConstraints(maxHeight: 56.v),
        contentPadding: EdgeInsets.only(top: 19.v, right: 30.h, bottom: 19.v));
  }

  /// Section Widget
  Widget _buildUpdateButton(BuildContext context) {
    return CustomElevatedButton(
        onPressed: () {
          _saveEvent();
        },
        text: "Create Event",
        margin: EdgeInsets.only(left: 24.h, right: 24.h, bottom: 49.v));
  }

  /// Navigates back to the previous screen.
  onTapArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }
}
