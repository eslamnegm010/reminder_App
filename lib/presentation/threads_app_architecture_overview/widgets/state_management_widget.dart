import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

// /home/ubuntu/app/eslam_s_application/lib/presentation/threads_app_architecture_overview/widgets/state_management_widget.dart





class StateManagementWidget extends StatelessWidget {
  final String codeExample;

  const StateManagementWidget({
    Key? key,
    required this.codeExample,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStateManagementIntro(),
            SizedBox(height: 24.h),
            _buildCodeExample(),
            SizedBox(height: 24.h),
            _buildStateManagementBestPractices(),
          ],
        ),
      ),
    );
  }

  Widget _buildStateManagementIntro() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(8.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(26),
            blurRadius: 4.h,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cubit State Management',
            style: TextStyleHelper.instance.title18Bold.copyWith(
              color: appTheme.blackCustom,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'This application uses Cubit for state management, which is a simplified version of BLoC that provides the same architectural benefits with less boilerplate code.',
            style: TextStyleHelper.instance.body14Regular.copyWith(
              color: appTheme.blackCustom,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Key Concepts:',
            style: TextStyleHelper.instance.title16SemiBold.copyWith(
              color: appTheme.blackCustom,
            ),
          ),
          SizedBox(height: 8.h),
          _buildConceptItem(
            'Immutable State',
            'Each state object is immutable, with a copyWith method for updates.',
          ),
          _buildConceptItem(
            'Status Enums',
            'State includes a status enum (loading, loaded, error, etc.) for UI rendering.',
          ),
          _buildConceptItem(
            'Extension Methods',
            'Helper extensions provide readable state checking (isLoading, isError, etc.).',
          ),
          _buildConceptItem(
            'Repository Pattern',
            'Cubits interact with repositories, which abstract data sources.',
          ),
        ],
      ),
    );
  }

  Widget _buildConceptItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 4.h),
            width: 8.h,
            height: 8.h,
            decoration: BoxDecoration(
              color: appTheme.blackCustom,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyleHelper.instance.title16SemiBold.copyWith(
                    color: appTheme.blackCustom,
                    fontSize: 14.fSize,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyleHelper.instance.body14Regular.copyWith(
                    color: appTheme.blackCustom,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeExample() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(8.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(26),
            blurRadius: 4.h,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Example State Implementation',
            style: TextStyleHelper.instance.title18Bold.copyWith(
              color: appTheme.blackCustom,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: appTheme.blackCustom,
              borderRadius: BorderRadius.circular(8.h),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                codeExample,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12.fSize,
                  color: appTheme.whiteCustom,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateManagementBestPractices() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(8.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(26),
            blurRadius: 4.h,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Best Practices',
            style: TextStyleHelper.instance.title18Bold.copyWith(
              color: appTheme.blackCustom,
            ),
          ),
          SizedBox(height: 16.h),
          _buildBestPracticeItem(
            'Single Responsibility',
            'Each Cubit should manage state for a single feature or screen.',
          ),
          _buildBestPracticeItem(
            'Immutable State',
            'Never modify state objects directly; create new ones with copyWith.',
          ),
          _buildBestPracticeItem(
            'Error Handling',
            'Always catch exceptions and update state with error information.',
          ),
          _buildBestPracticeItem(
            'State Granularity',
            'Include only necessary data in state objects to prevent excess rebuilds.',
          ),
          _buildBestPracticeItem(
            'Repository Abstraction',
            'Cubits should only interact with repositories, not data sources directly.',
          ),
          _buildBestPracticeItem(
            'Predictable State Changes',
            'Each emit should represent a complete, valid state of the application.',
          ),
        ],
      ),
    );
  }

  Widget _buildBestPracticeItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20.h,
          ),
          SizedBox(width: 8.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyleHelper.instance.title16SemiBold.copyWith(
                    color: appTheme.blackCustom,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyleHelper.instance.body14Regular.copyWith(
                    color: appTheme.blackCustom,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}