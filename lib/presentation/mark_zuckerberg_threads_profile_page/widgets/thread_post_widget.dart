import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../data/models/thread_post_model.dart';

// /home/ubuntu/app/eslam_s_application/lib/presentation/mark_zuckerberg_threads_profile_page/widgets/thread_post_widget.dart







class ThreadPostWidget extends StatelessWidget {
  final ThreadPostModel threadPost;

  ThreadPostWidget({Key? key, required this.threadPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: appTheme.colorFFD9D9, width: 1.h),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildThreadLine(context),
          SizedBox(width: 16.h),
          Expanded(child: _buildPostContent(context)),
        ],
      ),
    );
  }

  Widget _buildThreadLine(BuildContext context) {
    return Stack(
      children: [
        CustomImageView(
          imagePath: threadPost.profileImage,
          height: 47.h,
          width: 47.h,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 47.h,
          left: 19.h,
          child: CustomImageView(
            imagePath: ImageConstant.imgGap,
            height: 2.h,
            width: 8.h,
          ),
        ),
        Positioned(
          top: 55.h,
          left: 19.h,
          child: Container(
            height: threadPost.threadHeight,
            width: 2.h,
            color: appTheme.colorFFD9D9,
          ),
        ),
        Positioned(
          top: (55.h + threadPost.threadHeight),
          left: 19.h,
          child: CustomImageView(
            imagePath: ImageConstant.imgGap,
            height: 1.h,
            width: 8.h,
          ),
        ),
        Positioned(
          top: (63.h + threadPost.threadHeight),
          left: 1.h,
          child: CustomImageView(
            imagePath: ImageConstant.imgFrame3,
            height: 20.h,
            width: 37.h,
          ),
        ),
      ],
    );
  }

  Widget _buildPostContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  threadPost.username,
                  style: TextStyleHelper.instance.title18Bold.copyWith(
                    height: 1.2,
                  ),
                ),
                SizedBox(width: 8.h),
                if (threadPost.isVerified)
                  CustomImageView(
                    imagePath: ImageConstant.imgVectorBlueA200,
                    height: 16.h,
                    width: 15.h,
                  ),
              ],
            ),
            Row(
              children: [
                Text(
                  threadPost.timeAgo,
                  style: TextStyleHelper.instance.title18Regular.copyWith(
                    color: appTheme.colorFFB5B5,
                    height: 1.2,
                  ),
                ),
                SizedBox(width: 16.h),
                CustomImageView(
                  imagePath: ImageConstant.imgFrame3Black900,
                  height: 16.h,
                  width: 3.h,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          threadPost.content,
          style: TextStyleHelper.instance.title18Medium.copyWith(
            color: appTheme.blackCustom,
            height: 1.4,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgLikeButton,
              height: 22.h,
              width: 21.h,
            ),
            SizedBox(width: 20.h),
            CustomImageView(
              imagePath: ImageConstant.imgButtonImgComment,
              height: 22.h,
              width: 22.h,
            ),
            SizedBox(width: 20.h),
            CustomImageView(
              imagePath: ImageConstant.imgButtonImgRepost,
              height: 22.h,
              width: 22.h,
            ),
            SizedBox(width: 20.h),
            CustomImageView(
              imagePath: ImageConstant.imgButtonImgShare,
              height: 22.h,
              width: 22.h,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Text(
              '${threadPost.repliesCount} replies',
              style: TextStyleHelper.instance.title18Regular.copyWith(
                height: 1.2,
              ),
            ),
            SizedBox(width: 16.h),
            Text(
              '${threadPost.likesCount} likes',
              style: TextStyleHelper.instance.title18Regular.copyWith(
                height: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}