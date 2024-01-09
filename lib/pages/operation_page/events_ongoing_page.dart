import 'package:flutter/material.dart';
import 'package:sport_events/core/utils/size_utils.dart';
import 'package:sport_events/pages/operation_page/widgets/chat_page.dart';
import '../../../theme/app_decoration.dart';
import '../../components/app_bar/appbar_leading_image.dart';
import '../../components/app_bar/appbar_title.dart';
import '../../components/app_bar/appbar_trailing_image.dart';
import '../../components/app_bar/custom_app_bar.dart';
import '../../components/custom_elevated_button.dart';
import '../../components/custom_image_view.dart';
import '../../components/custom_outlined_button.dart';
import '../../core/model/event.model.dart';
import '../../core/service/event.service.dart';
import '../../core/utils/image_constant.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../event_details_screen/event_details_screen.dart';

class EventsOngoingPage extends StatefulWidget {
  const EventsOngoingPage({Key? key}) : super(key: key);

  @override
  EventsOngoingPageState createState() => EventsOngoingPageState();
}

class EventsOngoingPageState extends State<EventsOngoingPage>
    with AutomaticKeepAliveClientMixin<EventsOngoingPage> {
  @override
  bool get wantKeepAlive => true;

  late Stream<List<Event>> _eventsStream;

  @override
  void initState() {
    super.initState();
    _eventsStream = EventService().getEventsStreamForUser();
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
            title: AppbarTitle(
                text: "My events", margin: EdgeInsets.only(left: 16.h)),
            actions: [
              AppbarTrailingImage(
                imagePath: ImageConstant.imgIcons,
                margin: EdgeInsets.only(left: 24.h, top: 11.v, right: 11.h),
              ),
              AppbarTrailingImage(
                  imagePath: ImageConstant.imgClock,
                  margin: EdgeInsets.only(left: 20.h, top: 11.v, right: 35.h))
            ]),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: StreamBuilder<List<Event>>(
              stream: _eventsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LinearProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('No events');
                } else {
                  List<Event> userEvents = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: userEvents.length,
                    itemBuilder: (context, index) {
                      Event event = userEvents[index];
                      return Container(
                        margin: EdgeInsets.all(5.h),
                        padding: EdgeInsets.all(15.h),
                        //margin: EdgeInsets.only(left: 20.h, top: 11.v, right: 35.h),

                        decoration: AppDecoration.outlineBlackC.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                CustomImageView(
                                  imagePath: event.photoUrl,
                                  height: 100.adaptSize,
                                  width: 100.adaptSize,
                                  fit: BoxFit.cover,
                                  radius: BorderRadius.circular(
                                    16.h,
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 1.v),
                                ),
                                SizedBox(width: 16.h),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event.date + ' ' + event.location,
                                        style: theme.textTheme.titleLarge,
                                      ),
                                      SizedBox(height: 10.v),
                                      Text(
                                        event.name,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      SizedBox(height: 10.v),
                                      Row(
                                        children: [
                                          CustomImageView(
                                            imagePath:
                                                ImageConstant.imgStarYellowA700,
                                            height: 12.adaptSize,
                                            width: 12.adaptSize,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 2.v),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 4.h),
                                            child: Text(
                                              event.type,
                                              style: theme.textTheme.titleSmall,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 8.h,
                                              top: 1.v,
                                            ),
                                            child: Text(
                                              event.rule,
                                              style: theme.textTheme.bodySmall,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.v),
                            Divider(),
                            SizedBox(height: 19.v),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: CustomOutlinedButton(
                                    text: "Enjoin",
                                    margin: EdgeInsets.only(right: 6.h),
                                    onPressed: () {
                                      EventService().unjoinEvent(event.id!);
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: CustomElevatedButton(
                                    height: 38.v,
                                    text: "View details",
                                    margin: EdgeInsets.only(left: 6.h),
                                    buttonStyle:
                                        CustomButtonStyles.fillPrimaryTL19,
                                    buttonTextStyle:
                                        CustomTextStyles.titleMediumSemiBold,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EventDetailsScreen(event: event),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.chat),
                                  onPressed: () {
                                    // showModalBottomSheet(
                                    //   context: context,
                                    //   isScrollControlled: true,
                                    //   shape: const RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.vertical(
                                    //         top: Radius.circular(20)),
                                    //   ),
                                    //   builder: (context) {
                                    //     return EventChatPage(
                                    //       modalHeight: MediaQuery.of(context)
                                    //               .size
                                    //               .height *
                                    //           0.95,
                                    //       eventId: event.id,
                                    //     );
                                    //   },
                                    // );
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return EventChatPage(
                                          modalHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.9,
                                          event: event,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 19.v),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            )));
  }
}
