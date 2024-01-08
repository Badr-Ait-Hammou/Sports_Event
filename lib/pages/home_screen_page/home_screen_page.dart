import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_events/core/model/event.model.dart';
import 'package:sport_events/core/service/event.service.dart';
import 'package:sport_events/core/utils/size_utils.dart';
import 'package:sport_events/pages/add_event_screen/add_event_screen.dart';
import 'package:sport_events/pages/home_screen_page/widgets/hotelslist_item_widget.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';
import '../../components/app_bar/appbar_leading_image.dart';
import '../../components/app_bar/appbar_title.dart';
import '../../components/app_bar/appbar_trailing_image.dart';
import '../../components/app_bar/custom_app_bar.dart';
import '../../components/custom_image_view.dart';
import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({Key? key}) : super(key: key);

  @override
  HomeScreenPageState createState() => HomeScreenPageState();
}

class HomeScreenPageState extends State<HomeScreenPage>
    with AutomaticKeepAliveClientMixin<HomeScreenPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final DocumentSnapshot eventData;
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
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
                return LinearProgressIndicator();
              }

              List<QueryDocumentSnapshot> events = snapshot.data!.docs;
              List<Event> eventList =
                  events.map((e) => Event.fromFirestore(e)).toList();

              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 24.v);
                },
                itemCount: eventList.length,
                itemBuilder: (context, index) {
                  return _buildeventItem(context, eventList[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildeventItem(BuildContext context, Event event) {
    User? user = auth.currentUser;
    String currentUserId = user?.uid ?? '';
    String name = event.name;
    String date = event.date;
    String location = event.location;
    String type = event.type;
    String rule = event.rule;
    String photoUrl = event.photoUrl;
    print(
        "useer id $currentUserId check !!!!!! ${event.listParticipants.contains(currentUserId)}");
    int totalParticipants = int.parse(event.participant);
    int joinedParticipants = event.listParticipants.length;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.v),
      decoration: AppDecoration.outlineBlackC.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomImageView(
            imagePath: photoUrl,
            height: 100.adaptSize,
            width: 100.adaptSize,
            fit: BoxFit.cover,
            radius: BorderRadius.circular(
              16.h,
            ),
            margin: EdgeInsets.symmetric(vertical: 1.v),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 11.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$name",
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(height: 18.v),
                Text(
                  "$date-$location",
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: 12.v),
                Row(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgStarYellowA700,
                      height: 12.adaptSize,
                      width: 12.adaptSize,
                      margin: EdgeInsets.symmetric(vertical: 2.v),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.h),
                      child: Text(
                        "$type",
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8.h,
                        top: 1.v,
                      ),
                      child: Text(
                        "$rule ",
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
                  "$joinedParticipants/$totalParticipants participants",
                  style: CustomTextStyles.headlineSmallPrimary,
                ),
                SizedBox(height: 2.v),
                currentUserId == event.createdBy
                    ? Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.teal,
                          ),
                          onPressed: () async {
                            await EventService().deleteEvent(event.id);
                          },
                        ),
                      )
                    : Center(
                        child: IconButton(
                          icon: Icon(
                            event.listParticipants.contains(currentUserId)
                                ? Icons.verified_outlined
                                : Icons.add_alert_outlined,
                            color: Colors.teal,
                          ),
                          onPressed: (joinedParticipants < totalParticipants)
                              ? () async {
                                  await EventService().joinEvent(event.id);
                                }
                              : null,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        appBar: CustomAppBar(
            height: 50.v,
            leadingWidth: 56.h,
            leading: AppbarLeadingImage(
                imagePath: ImageConstant.logo,
                margin: EdgeInsets.only(left: 24.h, top: 9.v, bottom: 9.v)),
            title:
                AppbarTitle(text: "Home", margin: EdgeInsets.only(left: 16.h)),
            actions: [
              AppbarTrailingImage(
                  imagePath: ImageConstant.imgIcons,
                  margin: EdgeInsets.only(left: 24.h, top: 11.v, right: 11.h),
                  onTap: () {}),
              AppbarTrailingImage(
                  imagePath: ImageConstant.imgClock,
                  margin: EdgeInsets.only(left: 20.h, top: 11.v, right: 35.h))
            ]),
        body: SizedBox(
            width: mediaQueryData.size.width,
            child: SingleChildScrollView(
                child: Column(children: [
              SizedBox(height: 30.v),
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding: EdgeInsets.only(left: 24.h),
                      child: Column(children: [
                        _buildHotelsList(context),
                        SizedBox(height: 34.v),
                        _buildRecentlyBookedList(context)
                      ])))
            ]))),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 123, 122, 122),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return AddEventScreen(
                  modalHeight: MediaQuery.of(context).size.height * 0.95,
                );
              },
            );
          },
          tooltip: 'Add',
          child: Icon(Icons.add),
        ));
  }

  Widget _buildHotelsList(BuildContext context) {
    return SizedBox(
      height: 400.v,
      child: FutureBuilder<List<DocumentSnapshot>>(
        future: fetchDataFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          List<DocumentSnapshot> eventDataList = snapshot.data ?? [];

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return SizedBox(width: 24.h);
            },
            itemCount: eventDataList.length,
            itemBuilder: (context, index) {
              DocumentSnapshot eventData = eventDataList[index];
              return HotelslistItemWidget(
                eventData: eventData,
              );
            },
          );
        },
      ),
    );
  }

  Future<List<DocumentSnapshot>> fetchDataFromFirebase() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('events').get();
    return querySnapshot.docs;
  }
}
