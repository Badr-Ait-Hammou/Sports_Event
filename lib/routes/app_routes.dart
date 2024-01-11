import 'package:flutter/material.dart';
import 'package:sport_events/pages/add_event_screen/add_event_screen.dart';
import 'package:sport_events/pages/event_details_screen/event_details_screen.dart';
import 'package:sport_events/pages/event_list_page/my_events_page.dart';
import '../pages/container_screen/home_screen_container_screen.dart';
import '../pages/login_Page.dart';
import '../pages/profile_settings_page/profile_settings_page.dart';
import '../pages/signUp_Page.dart';
import '../pages/splash_Page.dart';

class AppRoutes {
  static const String splashScreen = '/splash';
  static const String loginScreen = '/login';
  static const String signUpScreen = '/signup';
  static const String dashboard = '/dashboard';
  static const String events = '/event';
  static const String addEvent = '/addEvent';
  static const String homeScreen = '/home';
  static const String profileScreen = '/profile';
  static const String eventDetailsScreen = '/eventdetails';
  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => SplashPage(),
    loginScreen: (context) => LoginPage(),
    signUpScreen: (context) => SignUpPage(),
    profileScreen: (context) => ProfilePage(),
    homeScreen: (context) => HomeContainerScreen(),
    events: (context) => MyEventsPage(),
    addEvent: (context) => AddEventScreen(),
    eventDetailsScreen: (context, {arguments}) => EventDetailsScreen(event: arguments['event']),  };
}
