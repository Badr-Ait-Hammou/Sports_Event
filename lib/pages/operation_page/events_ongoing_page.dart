import 'package:flutter/material.dart';
import 'package:sport_events/core/utils/size_utils.dart';
import 'package:sport_events/pages/operation_page/widgets/eventsPage.dart';
import '../../../theme/app_decoration.dart';
import '../../components/app_bar/appbar_leading_image.dart';
import '../../components/app_bar/appbar_title.dart';
import '../../components/app_bar/appbar_trailing_image.dart';
import '../../components/app_bar/custom_app_bar.dart';
import '../../core/utils/image_constant.dart';
import '../../routes/app_routes.dart';


class EventsOngoingPage extends StatefulWidget {
  const EventsOngoingPage({Key? key}) : super(key: key);

  @override
  EventsOngoingPageState createState() => EventsOngoingPageState();
}

class EventsOngoingPageState extends State<EventsOngoingPage>
    with AutomaticKeepAliveClientMixin<EventsOngoingPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return  Scaffold(
        appBar: CustomAppBar(
            height: 50.v,
            leadingWidth: 56.h,
            leading: AppbarLeadingImage(
                imagePath: ImageConstant.logo,
                margin: EdgeInsets.only(left: 24.h, top: 9.v, bottom: 9.v)),
            title:
            AppbarTitle(text: "Operations", margin: EdgeInsets.only(left: 16.h)),
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
            ]),
            body: Container(
                width: double.maxFinite,
                decoration: AppDecoration.fillOnPrimary,
                child: Column(children: [
                  SizedBox(height: 30.v),
                  _buildBookingOngoing(context)
                ])));
  }

  /// Section Widget
  Widget _buildBookingOngoing(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.h),
            child: ListView.separated(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 20.v);
                },
                itemCount: 2,
                itemBuilder: (context, index) {
                  return BookingongoingItemWidget(
                      onTapBookingActionCancelBooking: () {
                    onTapBookingActionCancelBooking(context);
                  }, onTapBookingActionViewTicket: () {
                    onTapBookingActionViewTicket(context);
                  });
                })));
  }

  onTapBookingActionCancelBooking(BuildContext context) {
    // TODO: implement Actions
  }

  /// Navigates to the viewTicketScreen when the action is triggered.
  onTapBookingActionViewTicket(BuildContext context) {
   // Navigator.pushNamed(context, AppRoutes.viewTicketScreen);
  }
}