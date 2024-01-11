import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sport_events/core/utils/size_utils.dart';

import '../../../components/custom_elevated_button.dart';
import '../../../components/custom_image_view.dart';
import '../../../core/utils/image_constant.dart';
import '../../../theme/custom_button_style.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';

class HomeTopSliderWidget extends StatelessWidget {
  final DocumentSnapshot eventData;

  const HomeTopSliderWidget({Key? key, required this.eventData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = eventData['name'] ?? '';
    String location = eventData['location'] ?? '';
    String address = eventData['address'] ?? '';
    String type = eventData['type'] ?? '';
    String rule = eventData['rule'] ?? '';
    String participant = eventData['participant'] ?? '';
    String photoUrl = eventData['photoUrl'] ?? '';
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          return SizedBox(
            height: 400.v,
            width: 300.h,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomImageView(
                  imagePath: photoUrl,
                  height: 400.v,
                  width: 300.h,
                  fit: BoxFit.cover,
                  radius: BorderRadius.circular(
                    36.h,
                  ),
                  alignment: Alignment.center,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomElevatedButton(
                            height: 32.v,
                            width: 100.h,
                            text: type,
                            margin: EdgeInsets.only(left: 10.h),
                            leftIcon: Container(
                              margin: EdgeInsets.only(right: 2.h),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgGrid,
                                height: 12.adaptSize,
                                width: 12.adaptSize,
                              ),
                            ),
                            buttonStyle: CustomButtonStyles.fillBlueGrayTL16,
                            buttonTextStyle: CustomTextStyles.titleSmallWhiteA700,
                          ),
                          Spacer(),
                          CustomElevatedButton(
                            height: 32.v,
                            width: 100.h,
                            text: address,
                            margin: EdgeInsets.only(right: 10.h),
                            leftIcon: Container(
                              margin: EdgeInsets.only(right: 2.h),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgLocation,
                                height: 12.adaptSize,
                                width: 12.adaptSize,
                              ),
                            ),
                            buttonStyle: CustomButtonStyles.fillBlueGrayTL16,
                            buttonTextStyle: CustomTextStyles.titleSmallWhiteA700,
                          ),
                        ],
                      ),
                      SizedBox(height: 240.v),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.h,
                          vertical: 21.v,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  name + " Event",
                                  style: theme.textTheme.headlineSmall,
                                ),
                                Spacer(),
                                CustomElevatedButton(
                                  height: 32.v,
                                  width: 50.h,
                                  text: "$participant ",
                                  margin: EdgeInsets.only(right: 1.h),
                                  leftIcon: Container(
                                    margin: EdgeInsets.only(right: 3.h),
                                    child: CustomImageView(
                                      imagePath: ImageConstant.imgUser,
                                      height: 12.adaptSize,
                                      width: 12.adaptSize,
                                    ),
                                  ),
                                  buttonStyle: CustomButtonStyles.fillBlueGrayTL16,
                                  buttonTextStyle: CustomTextStyles.titleSmallWhiteA700,
                                ),
                              ],
                            ),
                            SizedBox(height: 5.v),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 2.v),
                                  child: Text(
                                    " rules : " + rule,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
