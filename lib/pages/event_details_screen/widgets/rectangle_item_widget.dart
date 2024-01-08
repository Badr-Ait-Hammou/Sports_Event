
import 'package:flutter/material.dart';
import 'package:sport_events/core/utils/size_utils.dart';

import '../../../components/custom_image_view.dart';
import '../../../core/utils/image_constant.dart';

class RectangleItemWidget extends StatelessWidget {
  const RectangleItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140.h,
      child: CustomImageView(
        imagePath: ImageConstant.imgRectangle7,
        height: 100.v,
        width: 140.h,
        radius: BorderRadius.circular(
          16.h,
        ),
      ),
    );
  }
}
