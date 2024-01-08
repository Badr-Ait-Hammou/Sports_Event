
import 'package:flutter/material.dart';
import 'package:sport_events/core/utils/size_utils.dart';

import '../../../components/custom_elevated_button.dart';
import '../../../components/custom_image_view.dart';
import '../../../components/custom_outlined_button.dart';
import '../../../core/model/event.model.dart';
import '../../../core/service/event.service.dart';
import '../../../core/utils/image_constant.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_button_style.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';

class BookingongoingItemWidget extends StatefulWidget {
  const BookingongoingItemWidget({Key? key}) : super(key: key);

  @override
  State<BookingongoingItemWidget> createState() => _BookingongoingItemWidgetState();
}

class _BookingongoingItemWidgetState extends State<BookingongoingItemWidget> {

  late Stream<List<Event>> _eventsStream;

  @override
  void initState() {
    super.initState();
    _eventsStream = EventService().getEventsStreamForUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
      stream: EventService().getEventsStreamForUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('No events');
        } else {
          List<Event> userEvents = snapshot.data ?? [];
          return ListView.builder(
            itemCount: userEvents.length,
            itemBuilder: (context, index) {
              Event event = userEvents[index];
              return Container(
                padding: EdgeInsets.all(20.h),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    imagePath: ImageConstant.imgStarYellowA700,
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
                              EventService().joinEvent(event.id!);
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomElevatedButton(
                            height: 38.v,
                            text: "View details",
                            margin: EdgeInsets.only(left: 6.h),
                            buttonStyle: CustomButtonStyles.fillPrimaryTL19,
                            buttonTextStyle:
                            CustomTextStyles.titleMediumSemiBold,
                            onPressed: () {
                              // Handle view details
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}