import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';

// /home/ubuntu/app/eslam_s_application/lib/presentation/mark_zuckerberg_threads_profile_page/widgets/bottom_navigation_widget.dart






class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          _buildNavItem(ImageConstant.imgHome),
          _buildNavItem(ImageConstant.imgSearch),
          _buildNavItem(ImageConstant.imgWrite),
          _buildNavItem(ImageConstant.imgActivity),
          _buildNavItem(ImageConstant.imgProfile),
        ],
      ),
    );
  }

  Widget _buildNavItem(String iconPath) {
    return CustomImageView(
      imagePath: iconPath,
      height: 24.h,
      width: 24.h,
    );
  }
}