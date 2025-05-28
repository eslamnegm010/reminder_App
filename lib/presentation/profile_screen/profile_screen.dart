import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import './widgets/thread_post_widget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  List<ThreadPostModel> threadPosts = [
    ThreadPostModel(
      profileImage: ImageConstant.imgEllipse1,
      username: 'zuck',
      isVerified: true,
      timeAgo: '33m',
      content: '10 million sign ups in seven hours.',
      repliesCount: '26',
      likesCount: '112',
      threadHeight: 48.h,
    ),
    ThreadPostModel(
      profileImage: ImageConstant.imgEllipse1,
      username: 'zuck',
      isVerified: true,
      timeAgo: '7h',
      content: 'Just passed 5 million sign ups in the first four hours...',
      repliesCount: '26',
      likesCount: '112',
      threadHeight: 74.h,
    ),
    ThreadPostModel(
      profileImage: ImageConstant.imgEllipse1,
      username: 'zuck',
      isVerified: true,
      timeAgo: '9h',
      content: 'Threads just passed 2 million sign ups in the first two hours.',
      repliesCount: '26',
      likesCount: '112',
      threadHeight: 74.h,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context),
            _buildTabNavigation(context),
            _buildThreadsList(context),
            SizedBox(height: 80.h),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: appTheme.whiteCustom,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 60.h,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgVectorBlack900,
                height: 7.h,
                width: 14.h,
              ),
              SizedBox(width: 12.h),
              Text(
                'Back',
                style: TextStyleHelper.instance.title20Regular.copyWith(
                  color: appTheme.blackCustom,
                  height: 1.25,
                ),
              ),
            ],
          ),
          Row(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgInstagram,
                height: 24.h,
                width: 24.h,
              ),
              SizedBox(width: 16.h),
              CustomImageView(
                imagePath: ImageConstant.imgMore,
                height: 24.h,
                width: 24.h,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 24.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mark Zuckerberg',
                      style: TextStyleHelper.instance.headline30Bold.copyWith(
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Text(
                          'zuck',
                          style: TextStyleHelper.instance.headline24Regular
                              .copyWith(height: 1.2),
                        ),
                        SizedBox(width: 12.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.h,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: appTheme.colorFFF5F5,
                            borderRadius: BorderRadius.circular(16.h),
                          ),
                          child: Text(
                            'threads.net',
                            style: TextStyleHelper.instance.body14Regular
                                .copyWith(height: 1.2),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgUsersAlreadyFollowing,
                          height: 24.h,
                          width: 61.h,
                        ),
                        SizedBox(width: 8.h),
                        Text(
                          '412',
                          style: TextStyleHelper.instance.title20Regular
                              .copyWith(height: 1.2),
                        ),
                        SizedBox(width: 8.h),
                        Text(
                          'k followers',
                          style: TextStyleHelper.instance.title20Regular
                              .copyWith(height: 1.2),
                        ),
                        SizedBox(width: 8.h),
                        CustomImageView(
                          imagePath: ImageConstant.imgDot,
                          height: 3.h,
                          width: 3.h,
                        ),
                        SizedBox(width: 8.h),
                        Text(
                          'fb.com',
                          style: TextStyleHelper.instance.title20Regular
                              .copyWith(height: 1.2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.h),
              Stack(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgProfilePic,
                    height: 84.h,
                    width: 84.h,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 4.h,
                    left: 0,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgVector,
                      height: 21.h,
                      width: 22.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 11.h),
            decoration: BoxDecoration(
              color: appTheme.blackCustom,
              borderRadius: BorderRadius.circular(10.h),
            ),
            child: Text(
              'Follow',
              style: TextStyleHelper.instance.title18Medium.copyWith(
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: appTheme.colorFFD9D9, width: 1.h),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: appTheme.blackCustom, width: 2.h),
                ),
              ),
              child: Text(
                'Threads',
                style: TextStyleHelper.instance.title16SemiBold.copyWith(
                  height: 1.25,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                'Replies',
                style: TextStyleHelper.instance.title16SemiBold.copyWith(
                  color: appTheme.colorFF9999,
                  height: 1.25,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreadsList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: threadPosts.length,
      itemBuilder: (context, index) {
        return ThreadPostWidget(threadPost: threadPosts[index]);
      },
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        border: Border(
          top: BorderSide(color: appTheme.colorFFE5E5, width: 1.h),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgHome,
            height: 24.h,
            width: 24.h,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgSearch,
            height: 24.h,
            width: 24.h,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgWrite,
            height: 24.h,
            width: 24.h,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgActivity,
            height: 24.h,
            width: 24.h,
          ),
          CustomImageView(
            imagePath: ImageConstant.imgProfile,
            height: 24.h,
            width: 24.h,
          ),
        ],
      ),
    );
  }
}