import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_events/core/utils/size_utils.dart';

import '../components/custom_image_view.dart';
import '../core/utils/image_constant.dart';
import '../routes/app_routes.dart';
import '../theme/custom_text_style.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late MediaQueryData mediaQueryData;
  late ThemeData theme;

  @override
  void initState() {
    Timer(Duration(seconds: 3), () async {
      await init();
    });
    super.initState();
  }

  Future<void> init() async {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushNamed(context, AppRoutes.homeScreen);
    } else {
      Navigator.pushNamed(context, AppRoutes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    theme = Theme.of(context);

    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            CustomImageView(
              imagePath: ImageConstant.splashimg1,
              height: 420.v,
              width: 428.h,
            ),
            SizedBox(height: 76.v),
            _buildWelcomeSection(context),
            SizedBox(height: 5.v),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to",
            style: theme.textTheme.displayMedium,
          ),
          SizedBox(height: 23.v),
          Text(
            "Event Pulse ",
            style: theme.textTheme.displayLarge,
          ),
          SizedBox(height: 40.v),
          Container(
            width: 319.h,
            margin: EdgeInsets.only(right: 44.h),
            child: Text(
              "Empower Your Journey,Have fun , Do some sports",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.titleMediumSemiBold_1.copyWith(
                height: 1.50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
