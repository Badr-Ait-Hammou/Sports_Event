import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:sport_events/components/custom_outlined_button.dart';
import 'package:sport_events/core/service/user.service.dart';
import 'package:sport_events/pages/login_Page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/app_bar/appbar_leading_image.dart';
import '../../components/app_bar/appbar_title.dart';
import '../../components/app_bar/appbar_trailing_image.dart';
import '../../components/app_bar/custom_app_bar.dart';
import '../../components/custom_bottom_bar.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_image_view.dart';
import '../../components/custom_switch.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../routes/app_routes.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  bool isSelectedSwitch = false;

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 30.v),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(
              future: UserService().getUserInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LinearProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  Map<String, dynamic> userInfo = snapshot.data as Map<String, dynamic>;
                  return Column(
                    children: [
                      _buildProfile(context, userInfo),
                      SizedBox(height: 60.v),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomOutlinedButton(
                            height: 40.v,
                            width: 148.h,
                            text: "Update",
                            leftIcon: Container(
                              margin: EdgeInsets.only(right: 20.h),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgEdit,
                                height: 28.adaptSize,
                                width: 28.adaptSize,
                              ),
                            ),
                            buttonStyle: CustomButtonStyles.none,
                            buttonTextStyle: CustomTextStyles.titleMediumSemiBold_1,
                            onPressed: () {
                              _showUpdateProfileDialog(context);
                            },
                          ),
                          SizedBox(width: 20.h), // Adjust the spacing between buttons
                          CustomOutlinedButton(
                            height: 40.v,
                            width: 148.h,
                            text: "Logout",
                            leftIcon: Container(
                              margin: EdgeInsets.only(right: 20.h),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgRefresh,
                                height: 28.adaptSize,
                                width: 28.adaptSize,
                              ),
                            ),
                            buttonStyle: CustomButtonStyles.none,
                            buttonTextStyle: CustomTextStyles.titleMediumSemiBold_1,
                            onPressed: () async {
                              await UserService().logout();
                              Navigator.of(context, rootNavigator: true)
                                  .pushReplacement(MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30.v),
                      SizedBox(height: 5.v),
                    ],
                  );

                } else {
                  return Text('No data available');
                }
              },
            ),
          ],
        ),
      ),
    );
  }


  void _showUpdateProfileDialog(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Profile", style: TextStyle(color: Colors.black),),
          content: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                style: TextStyle(color: Colors.black),
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                style: TextStyle(color: Colors.black),

              ),
            ],
          ),
          actions: [
            CustomElevatedButton(
              height: 28.v,
              width: 114.h,
              text: 'update',
              onPressed: () async {
                await UserService().updateUserProfile(
                  firstNameController.text,
                  lastNameController.text,
                );
                Navigator.pop(context);
              },
            ),
            CustomElevatedButton(
              height: 28.v,
              width: 114.h,
              text:"cancel",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        height: 50.v,
        leadingWidth: 56.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.logo,
            margin: EdgeInsets.only(left: 24.h, top: 9.v, bottom: 9.v),
            onTap: () {
              onTapGoogle(context);
            }),
        title:
            AppbarTitle(text: "Profile", margin: EdgeInsets.only(left: 16.h)),
        actions: [
          AppbarTrailingImage(
              imagePath: ImageConstant.imgClock,
              margin: EdgeInsets.symmetric(horizontal: 24.h, vertical: 11.v))
        ]);
  }

  Widget _buildProfile(BuildContext context, Map<String, dynamic> userInfo) {
    return Column(
      children: [
        SizedBox(
          height: 120.adaptSize,
          width: 120.adaptSize,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Center(
                child: Initicon(
                  text: "${userInfo['firstName']} ${userInfo['lastName']}",
                  backgroundColor: Colors.teal,
                  size: 80.0, // Adjust the size as needed
                  elevation: 8,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.v),
        Text("${userInfo['firstName']} ${userInfo['lastName']}", style: theme.textTheme.headlineSmall),
        SizedBox(height: 11.v),
        Text("${userInfo['email']}", style: CustomTextStyles.titleSmallWhiteA700),
      ],
    );
  }

  /// Opens a URL in the device's default web browser.
  ///
  /// The [context] parameter is the `BuildContext` of the widget that invoked the function.
  ///
  /// Throws an exception if the URL could not be launched.
  onTapGoogle(BuildContext context) async {
    var url = 'https://accounts.google.com/';
    if (!await launch(url)) {
      throw 'Could not launch https://accounts.google.com/';
    }
  }

  /// Navigates to the editProfileScreen when the action is triggered.
  onTapEditProfile(BuildContext context) {
    //Navigator.pushNamed(context, AppRoutes.editProfileScreen);
  }

  /// Navigates to the notificationSettingsScreen when the action is triggered.
  onTapNotifications(BuildContext context) {
    // Navigator.pushNamed(context, AppRoutes.notificationSettingsScreen);
  }

  /// Navigates to the securityScreen when the action is triggered.
  onTapSecurity(BuildContext context) {
    // Navigator.pushNamed(context, AppRoutes.securityScreen);
  }
}
