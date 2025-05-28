import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../data/enum/architecture_tab_enum.dart';

// /home/ubuntu/app/eslam_s_application/lib/presentation/threads_app_architecture_overview/widgets/tab_navigation_widget.dart






class ArchitectureTabNavigationWidget extends StatelessWidget {
  final ArchitectureTab selectedTab;
  final Function(ArchitectureTab) onTabSelected;

  const ArchitectureTabNavigationWidget({
    Key? key,
    required this.selectedTab,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        border: Border(
          bottom: BorderSide(color: appTheme.colorFFD9D9, width: 1.h),
        ),
      ),
      child: Row(
        children: ArchitectureTab.values.map((tab) => _buildTabItem(context, tab)).toList(),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, ArchitectureTab tab) {
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