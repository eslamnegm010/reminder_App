import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../data/enum/threads_tab_enum.dart';

// /home/ubuntu/app/eslam_s_application/lib/presentation/mark_zuckerberg_threads_profile_page/widgets/tab_navigation_widget.dart






class TabNavigationWidget extends StatelessWidget {
  final ThreadsTab selectedTab;
  final Function(ThreadsTab) onTabSelected;

  const TabNavigationWidget({
    Key? key,
    required this.selectedTab,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: appTheme.colorFFD9D9, width: 1.h),
        ),
      ),
      child: Row(
        children: [
          _buildTabItem(context, ThreadsTab.threads),
          _buildTabItem(context, ThreadsTab.replies),
        ],
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, ThreadsTab tab) {
    final isSelected = selectedTab == tab;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(tab),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? appTheme.blackCustom : appTheme.transparentCustom,
                width: isSelected ? 2.h : 0,
              ),
            ),
          ),
          child: Text(
            tab.name,
            style: TextStyleHelper.instance.title16SemiBold.copyWith(
              color: isSelected ? appTheme.blackCustom : appTheme.colorFF9999,
              height: 1.25,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}