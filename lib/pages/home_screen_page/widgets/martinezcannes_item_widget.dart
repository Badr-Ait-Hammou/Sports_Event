import 'package:flutter/material.dart';
import 'package:sport_events/core/utils/size_utils.dart';

import '../../../components/custom_image_view.dart';
import '../../../core/utils/image_constant.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';
import 'eventform.dart';

class MartinezcannesItemWidget extends StatelessWidget {
  const MartinezcannesItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 18.v),
          decoration: AppDecoration.outlineBlackC.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgRectangle4,
                height: 100.adaptSize,
                width: 100.adaptSize,
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
                      "Martinez Cannes",
                      style: theme.textTheme.titleLarge,
                    ),
                    SizedBox(height: 18.v),
                    Text(
                      "Paris, France",
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
                            "4.8",
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 8.h,
                            top: 1.v,
                          ),
                          child: Text(
                            "(4,378 reviews)",
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
                      "32",
                      style: CustomTextStyles.headlineSmallPrimary,
                    ),
                    SizedBox(height: 2.v),
                    Text(
                      "/ night",
                      style: theme.textTheme.labelMedium,
                    ),
                    SizedBox(height: 16.v),
                    CustomImageView(
                      imagePath: ImageConstant.imgBookmarkPrimary,
                      height: 24.adaptSize,
                      width: 24.adaptSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16.0, // Adjust the position as needed
          right: 16.0, // Adjust the position as needed
          child: FloatingActionButton(
            onPressed: () {
              // Navigate to the page where you create a new event
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventCreationForm()),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Events'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('events').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           var events = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: events.length,
//             itemBuilder: (context, index) {
//               var event = events[index].data() as Map<String, dynamic>;
//               return EventListItem(event: event);
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to the page where you create a new event
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => EventCreationForm()),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
//
