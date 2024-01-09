import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sport_events/components/custom_outlined_button.dart';
import 'package:sport_events/core/service/event.service.dart';
import 'package:sport_events/pages/event_details_screen/widgets/framenineteen_item_widget.dart';
import 'package:sport_events/pages/event_details_screen/widgets/rectangle_item_widget.dart';

import '../../components/app_bar/appbar_leading_image.dart';
import '../../components/app_bar/appbar_title.dart';
import '../../components/app_bar/appbar_trailing_image.dart';
import '../../components/app_bar/custom_app_bar.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_image_view.dart';
import '../../core/model/event.model.dart';
import '../../core/service/user.service.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;
  final FirebaseAuth auth = FirebaseAuth.instance;

  EventDetailsScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            appBar: _buildAppBar(context),
            body: SizedBox(
                width: mediaQueryData.size.width,
                child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 5.v),
                        child: Column(children: [
                          _buildEightySeven(context),
                          SizedBox(height: 24.v),
                          _buildHotelDetails(context),
                          SizedBox(height: 35.v),
                          _buildCreatorHeadline(context),
                          _buildCreator(context),
                          SizedBox(height: 33.v),
                          _buildReview(context),
                          _buildDescription(context),
                          SizedBox(height: 31.v),
                          _buildLocation(context),
                          SizedBox(height: 32.v),
                          SizedBox(height: 40.v),
                          _buildPrice(context)
                        ]))))));
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        height: 50.v,
        leadingWidth: 56.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.logo,
            margin: EdgeInsets.only(left: 24.h, top: 9.v, bottom: 9.v)),
        title: AppbarTitle(
            text: event.name + " Event Details",
            margin: EdgeInsets.only(left: 16.h)),
        actions: [
          AppbarTrailingImage(
            imagePath: ImageConstant.imgIcons,
            margin: EdgeInsets.only(left: 24.h, top: 11.v, right: 11.h),
          ),
          AppbarTrailingImage(
              imagePath: ImageConstant.imgClock,
              margin: EdgeInsets.only(left: 20.h, top: 11.v, right: 35.h))
        ]);
  }

//   /// Section Widget
  Widget _buildEightySeven(BuildContext context) {
    return SizedBox(
        height: 400.v,
        width: double.maxFinite,
        child: Stack(alignment: Alignment.center, children: [
          CustomImageView(
              imagePath: event.photoUrl,
              height: 400.v,
              width: 428.h,
              fit: BoxFit.cover,
              alignment: Alignment.center),
          Align(
              alignment: Alignment.center,
              child: Container(

                 // decoration: AppDecoration.gradient,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 176.v),
                        // SizedBox(
                        //     height: 6.v,
                        //     child: AnimatedSmoothIndicator(
                        //         activeIndex: 0,
                        //         count: 5,
                        //         effect: ScrollingDotsEffect(
                        //             spacing: 11,
                        //             activeDotColor: theme.colorScheme.primary,
                        //             dotColor: appTheme.gray700,
                        //             dotHeight: 6.v,
                        //             dotWidth: 6.h)))
                      ])))
        ]));
  }

  /// Section Widget
  Widget _buildHotelDetails(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(event.name + " Event", style: theme.textTheme.headlineLarge),
          SizedBox(height: 15.v),
          Row(children: [
            CustomImageView(
                imagePath: ImageConstant.imgLocation,
                height: 20.adaptSize,
                width: 20.adaptSize),
            Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: Text(event.location,
                    style: CustomTextStyles.bodyMediumGray50_1)),
            Spacer(),
            CustomOutlinedButton(
              height: 32.v,
              width: 120.h,
              text: event.date,
              margin: EdgeInsets.symmetric(vertical: 8.v),
              leftIcon: Container(
                margin: EdgeInsets.only(right: 8.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgCalendar,
                  height: 12.adaptSize,
                  width: 12.adaptSize,
                ),
              ),
              // buttonStyle: CustomButtonStyles.fillPrimaryTL16,
              buttonTextStyle: CustomTextStyles.titleSmallWhiteA700,
            ),
          ])
        ]));
  }

  Widget _buildDescription(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24.h,
          vertical: 22.v,
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: event.listParticipants.map((participantId) {
              return Card(
                  elevation: 1.0,
                  color: Color.fromRGBO(79, 78, 78, 0.7294117647058823),
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          FutureBuilder(
                            future:
                                UserService().getUserInfoById(participantId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text("Error loading participant info");
                              } else {
                                Map<String, dynamic> participantInfo =
                                    snapshot.data as Map<String, dynamic>;
                                String firstName = participantInfo['firstName'];
                                String lastName = participantInfo['lastName'];

                                return Center(
                                  child: Initicon(
                                    text: "$firstName $lastName",
                                    backgroundColor: Colors.teal,
                                    size: 40.0,
                                    elevation: 8,
                                  ),
                                );
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 16.h,
                              top: 7.v,
                              bottom: 3.v,
                            ),
                            child: FutureBuilder(
                              future:
                                  UserService().getUserInfoById(participantId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text("Error loading participant info");
                                } else {
                                  Map<String, dynamic> participantInfo =
                                      snapshot.data as Map<String, dynamic>;
                                  String firstName =
                                      participantInfo['firstName'];
                                  String lastName = participantInfo['lastName'];

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$firstName $lastName",
                                        style: CustomTextStyles.titleMedium16,
                                      ),
                                      SizedBox(height: 2.v),
                                      Text(
                                        "Dec 10, 2024",
                                        style: CustomTextStyles
                                            .labelLargeGray40001,
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                          Spacer(),
                          CustomElevatedButton(
                            height: 32.v,
                            width: 60.h,
                            text: "5",
                            margin: EdgeInsets.symmetric(vertical: 8.v),
                            leftIcon: Container(
                              margin: EdgeInsets.only(right: 8.h),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgStar,
                                height: 12.adaptSize,
                                width: 12.adaptSize,
                              ),
                            ),
                            buttonStyle: CustomButtonStyles.fillPrimaryTL16,
                            buttonTextStyle:
                                CustomTextStyles.titleSmallWhiteA700,
                          ),
                        ],
                      )));
            }).toList()));
  }

  Widget _buildCreator(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.h,
        vertical: 22.v,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 24.h,
        vertical: 22.v,
      ),
      decoration: AppDecoration.outlineBlackC.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: UserService().getUserInfoById(event.createdBy),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error loading creator info");
              } else {
                Map<String, dynamic> creatorInfo =
                snapshot.data as Map<String, dynamic>;
                String creatorFirstName = creatorInfo['firstName'];
                String creatorLastName = creatorInfo['lastName'];
                String creatorEmail = creatorInfo['email'];

                return Row(
                  children: [
                    Center(
                      child: Initicon(
                        text: "$creatorFirstName $creatorLastName",
                        backgroundColor: Colors.teal,
                        size: 40.0,
                        elevation: 8,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16.h,
                        top: 7.v,
                        bottom: 3.v,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$creatorFirstName $creatorLastName",
                            style: CustomTextStyles.titleMedium16,
                          ),
                          SizedBox(height: 2.v),
                          Text(
                            creatorEmail,
                            style: CustomTextStyles.labelLargeGray40001,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          SizedBox(height: 11.v),
        ],
      ),
    );
  }


  /// Section Widget
  Widget _buildLocation(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Location", style: theme.textTheme.titleMedium),
          SizedBox(height: 18.v),
          SizedBox(
              height: 180.v,
              width: 380.h,
              child: Stack(alignment: Alignment.center, children: [
                SizedBox(
                    height: 180.v,
                    width: 380.h,
                    child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                            target:
                                LatLng(37.43296265331129, -122.08832357078792),
                            zoom: 14.4746),
                        onMapCreated: (GoogleMapController controller) {
                          // googleMapController.complete(controller);
                        },
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: false,
                        myLocationButtonEnabled: false,
                        myLocationEnabled: false)),
                CustomImageView(
                    imagePath: ImageConstant.imgLocation,
                    height: 40.adaptSize,
                    width: 40.adaptSize,
                    alignment: Alignment.center)
              ]))
        ]));
  }

  /// Section Widget
  Widget _buildReview(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Participants", style: theme.textTheme.titleMedium),
                CustomImageView(
                    imagePath: ImageConstant.imgUser,
                    height: 16.adaptSize,
                    width: 16.adaptSize,
                    margin: EdgeInsets.only(left: 21.h, bottom: 4.v)),
                Spacer(),
                GestureDetector(
                    onTap: () {},
                    child: Text("See All",
                        style: CustomTextStyles.titleMediumPrimary16))
              ]),
        ]));
  }
Widget _buildCreatorHeadline(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("The Event Creator", style: theme.textTheme.titleMedium),
                CustomImageView(
                    imagePath: ImageConstant.imgUser,
                    height: 16.adaptSize,
                    width: 16.adaptSize,
                    margin: EdgeInsets.only(left: 21.h, bottom: 4.v)),

                Spacer(),
                GestureDetector(
                    onTap: () {},
                    child: Text("See details",
                        style: CustomTextStyles.titleMediumPrimary16))
              ]),
        ]));
  }

  /// Section Widget
  Widget _buildPrice(BuildContext context) {
    User? user = auth.currentUser;
    String currentUserId = user?.uid ?? '';
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 9.v),
              child: Text(event.participant,
                  style: CustomTextStyles.headlineLargePrimary)),
          Padding(
              padding: EdgeInsets.only(left: 4.h, top: 20.v, bottom: 21.v),
              child: Text("Participant",
                  style: CustomTextStyles.bodyMediumGray40001)),
          CustomElevatedButton(
              height: 58.v,
              width: 263.h,
              text: event.listParticipants.contains(currentUserId)
                  ? "Enjoin"
                  : "Join Now",
              margin: EdgeInsets.only(left: 17.h),
              buttonStyle: CustomButtonStyles.outlineGreenAF,
              onPressed: () {
                if (event.listParticipants.contains(currentUserId)) {
                  EventService().unjoinEvent(event.id);
                } else {
                  EventService().joinEvent(event.id);
                }
              })
        ]));
  }
}
