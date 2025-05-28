import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../data/models/profile_model.dart';

// /home/ubuntu/app/eslam_s_application/lib/presentation/mark_zuckerberg_threads_profile_page/widgets/profile_header_widget.dart







class ProfileHeaderWidget extends StatelessWidget {
  final ProfileModel profile;
  final bool isFollowing;
  final VoidCallback onFollowPressed;

  const ProfileHeaderWidget({
    Key? key,
    required this.profile,
    required this.isFollowing,
    required this.onFollowPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      profile.name,
                      style: TextStyleHelper.instance.headline30Bold.copyWith(
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Text(
                          profile.username,
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
                          imagePath: profile.followersImages.isNotEmpty
                              ? profile.followersImages.first
                              : ImageConstant.imgUsersAlreadyFollowing,
                          height: 24.h,
                          width: 61.h,
                        ),
                        SizedBox(width: 8.h),
                        Text(
                          profile.followersCount,
                          style: TextStyleHelper.instance.title20Regular
                              .copyWith(height: 1.2),
                        ),
                        SizedBox(width: 8.h),
                        Text(
                          'followers',
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
                          profile.website,
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
                    imagePath: profile.profilePicture,
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
          GestureDetector(
            onTap: onFollowPressed,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 11.h),
              decoration: BoxDecoration(
                color: isFollowing ? appTheme.whiteCustom : appTheme.blackCustom,
                borderRadius: BorderRadius.circular(10.h),
                border: isFollowing
                    ? Border.all(color: appTheme.colorFFD9D9, width: 1.h)
                    : null,
              ),
              child: Text(
                isFollowing ? 'Following' : 'Follow',
                style: TextStyleHelper.instance.title18Medium.copyWith(
                  height: 1.2,
                  color: isFollowing ? appTheme.blackCustom : appTheme.whiteCustom,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}