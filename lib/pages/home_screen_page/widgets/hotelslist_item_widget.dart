import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sport_events/core/utils/size_utils.dart';

import '../../../components/custom_elevated_button.dart';
import '../../../components/custom_image_view.dart';
import '../../../core/utils/image_constant.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_button_style.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';

class HotelslistItemWidget extends StatelessWidget {
  final DocumentSnapshot eventData;

  const HotelslistItemWidget({Key? key, required this.eventData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = eventData['name'] ?? '';
    String location = eventData['location'] ?? '';
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
                      CustomElevatedButton(
                        height: 32.v,
                        width: 71.h,
                        text: type,
                        margin: EdgeInsets.only(right: 23.h),
                        leftIcon: Container(
                          margin: EdgeInsets.only(right: 8.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgStar,
                            height: 12.adaptSize,
                            width: 12.adaptSize,
                          ),
                        ),
                        buttonStyle: CustomButtonStyles.fillPrimaryTL16,
                        buttonTextStyle: CustomTextStyles.titleSmallWhiteA700,
                      ),
                      SizedBox(height: 172.v),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.h,
                          vertical: 21.v,
                        ),
                        decoration: AppDecoration.gradient.copyWith(
                          borderRadius: BorderRadiusStyle.customBorderBL36,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(height: 16.v),
                            Text(
                              name,
                              style: theme.textTheme.headlineSmall,
                            ),
                            SizedBox(height: 15.v),
                            Text(
                              location,
                              style: theme.textTheme.bodyLarge,
                            ),
                            SizedBox(height: 10.v),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 2.v),
                                  child: Text(
                                    "$participant Participants",
                                    style: theme.textTheme.headlineSmall,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 4.h,
                                    top: 9.v,
                                    bottom: 5.v,
                                  ),
                                  child: Text(
                                    rule,
                                    style: CustomTextStyles.bodyMediumWhiteA700,
                                  ),
                                ),
                                Spacer(),
                                CustomImageView(
                                  imagePath: ImageConstant.imgBookmark,
                                  height: 28.adaptSize,
                                  width: 28.adaptSize,
                                  margin: EdgeInsets.only(bottom: 3.v),
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
