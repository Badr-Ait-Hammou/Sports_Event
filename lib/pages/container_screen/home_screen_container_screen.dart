import 'package:flutter/material.dart';
import 'package:sport_events/core/model/event.model.dart';
import 'package:sport_events/pages/event_details_screen/event_details_screen.dart';
import 'package:sport_events/pages/event_list_page/my_events_page.dart';
import '../../components/custom_bottom_bar.dart';
import '../../core/utils/size_utils.dart';
import '../../routes/app_routes.dart';
import '../home_screen_page/home_screen_page.dart';
import '../profile_settings_page/profile_settings_page.dart';

class HomeContainerScreen extends StatelessWidget {
  HomeContainerScreen({Key? key}) : super(key: key);

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        body: Navigator(
            key: navigatorKey,
            initialRoute: AppRoutes.homeScreen,
            onGenerateRoute: (routeSetting) => PageRouteBuilder(
                pageBuilder: (ctx, ani, ani1) =>
                    getCurrentPage(routeSetting.name!),
                transitionDuration: Duration(seconds: 0))),
        bottomNavigationBar: _buildBottomBar(context));
  }

  /// Section Widget
  Widget _buildBottomBar(BuildContext context) {
    return CustomBottomBar(onChanged: (BottomBarEnum type) {
      Navigator.pushNamed(navigatorKey.currentContext!, getCurrentRoute(type));
    });
  }

  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return AppRoutes.homeScreen;
      case BottomBarEnum.Events:
        return AppRoutes.events;
      case BottomBarEnum.Profile:
        return AppRoutes.profileScreen;
      default:
        return "/";
    }
  }

  ///Handling page based on route
  Widget getCurrentPage(String currentRoute, {Object? arguments}) {
    switch (currentRoute) {
      case AppRoutes.homeScreen:
        return HomeScreenPage();
      case AppRoutes.events:
        return MyEventsPage();
      case AppRoutes.profileScreen:
        return ProfilePage();
      case AppRoutes.eventDetailsScreen:
        if (arguments != null &&
            arguments is Map<String, dynamic> &&
            arguments.containsKey('events') &&
            arguments['events'] is Event) {
          return EventDetailsScreen(event: arguments['events']);
        } else {
          return DefaultWidget();
        }
      default:
        return DefaultWidget();
    }
  }
}
