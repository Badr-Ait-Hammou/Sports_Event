import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sport_events/components/custom_outlined_button.dart';
import 'package:sport_events/core/service/event.service.dart';
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
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                    SizedBox(height: 176.v),
                  ])))
        ]));
  }

  /// Section Widget
  Widget _buildHotelDetails(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(event.name + " Event", style: theme.textTheme.headlineLarge),
                Spacer(),
                CustomOutlinedButton(
                  height: 40.v,
                  width: 50.h,
                  leftIcon: Icon(Icons.share),
                  text: "",
                  margin: EdgeInsets.only(left: 17.h),
                  //buttonStyle: CustomButtonStyles.outlineGreenAF,
                  onPressed: () {
                    Share.share(
                        '''
              🌟 Check Out This Event 🎉
              📅 Date: ${event.date}
              📍 Address: ${event.address}
              ✨ Name: ${event.name}
              🚀 Type: ${event.type}
              📜 Rule: ${event.rule}
              '''
                    );
                  },
                )
              ],),
          SizedBox(height: 15.v),
          Row(children: [
            CustomImageView(
                imagePath: ImageConstant.imgLocation,
                height: 20.adaptSize,
                width: 20.adaptSize),
            Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: Text(event.address,
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
                                  String firstName = participantInfo['firstName'];
                                  String lastName = participantInfo['lastName'];
                                  String email = participantInfo['email'];


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
                                        "$email",
                                        style: CustomTextStyles
                                            .labelLargeGray40001,
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
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
    List<String> locationParts = event.location.split(', ');
    double eventLatitude = double.parse(locationParts[0]);
    double eventLongitude = double.parse(locationParts[1]);
    var marker = Marker(
      point: LatLng(eventLatitude, eventLongitude),
      child: Icon(Icons.location_pin, color: Colors.red),
    );
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Location", style: theme.textTheme.titleMedium),
          SizedBox(height: 18.v),
          Container(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(eventLatitude, eventLongitude),
                  zoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(markers: [marker]),
                ],
              ),
            ),
          ),
        ])
    );
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
                    margin: EdgeInsets.only(left: 21.h, top: 4.v)),
                Spacer(),
                GestureDetector(
                    onTap: () {},
                    child:
                        Text("", style: CustomTextStyles.titleMediumPrimary16))
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
                Text("Description", style: theme.textTheme.titleMedium),
                CustomImageView(
                    imagePath: ImageConstant.imgFavoriteWhiteA700,
                    height: 16.adaptSize,
                    width: 16.adaptSize,
                    margin: EdgeInsets.only(left: 15.h, top: 4.v)),
                Spacer(),
                GestureDetector(
                    child: Text("", style: CustomTextStyles.titleMediumPrimary16))
              ]),
          SizedBox(height: 10.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  event.description,
                  style: CustomTextStyles.labelLargeGray40001,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.v),
          Divider(),
          SizedBox(height: 10.v),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("The Event Creator", style: theme.textTheme.titleMedium),
                CustomImageView(
                    imagePath: ImageConstant.imgUser,
                    height: 16.adaptSize,
                    width: 16.adaptSize,
                    margin: EdgeInsets.only(left: 15.h, top: 4.v)),
                Spacer(),
                GestureDetector(
                    onTap: () {},
                    child:
                    Text("", style: CustomTextStyles.titleMediumPrimary16))
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
              width: 250.h,
              text: event.listParticipants.contains(currentUserId)
                  ? "Enjoin"
                  : (event.createdBy == currentUserId ? "Delete Event" : "Join Now"),
              margin: EdgeInsets.only(left: 17.h),
              buttonStyle: CustomButtonStyles.outlineGreenAF,
              onPressed: () {
                if (event.listParticipants.contains(currentUserId)) {
                  EventService().unjoinEvent(context, event.id);
                } else if(event.createdBy== currentUserId){
                  EventService().deleteEvent(context, event.id);
                }else{
                  EventService().joinEvent(context, event.id);
                }
              }),

        ]));
  }
}
