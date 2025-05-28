import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

// /home/ubuntu/app/eslam_s_application/lib/presentation/threads_app_architecture_overview/widgets/implementation_examples_widget.dart





class ImplementationExamplesWidget extends StatelessWidget {
  final String codeExample;

  const ImplementationExamplesWidget({
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
            _buildImplementationIntro(),
            SizedBox(height: 24.h),
            _buildCodeExample(),
            SizedBox(height: 24.h),
            _buildImplementationSteps(),
          ],
        ),
      ),
    );
  }

  Widget _buildImplementationIntro() {
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
            'Feature Implementation',
            style: TextStyleHelper.instance.title18Bold.copyWith(
              color: appTheme.blackCustom,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'This example demonstrates a complete implementation of a feature following the architecture pattern. It includes all layers from data source to UI.',
            style: TextStyleHelper.instance.body14Regular.copyWith(
              color: appTheme.blackCustom,
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
            'Complete Feature Example',
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

  Widget _buildImplementationSteps() {
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
            'Implementation Steps',
            style: TextStyleHelper.instance.title18Bold.copyWith(
              color: appTheme.blackCustom,
            ),
          ),
          SizedBox(height: 16.h),
          _buildStepItem(
            '1',
            'Data Layer Setup',
            'Define data sources, models, and repositories for your feature.',
          ),
          _buildStepItem(
            '2',
            'State Definition',
            'Create state class with status enum and necessary data fields.',
          ),
          _buildStepItem(
            '3',
            'Cubit Implementation',
            'Implement Cubit with methods for all feature interactions.',
          ),
          _buildStepItem(
            '4',
            'UI Components',
            'Create reusable widgets specific to the feature.',
          ),
          _buildStepItem(
            '5',
            'Screen Integration',
            'Build the main screen that uses BlocProvider and BlocBuilder.',
          ),
          _buildStepItem(
            '6',
            'Dependency Injection',
            'Set up proper injection of repositories and data sources.',
          ),
          _buildStepItem(
            '7',
            'Testing',
            'Write unit tests for all layers, especially for Cubits and Repositories.',
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.h,
            height: 24.h,
            decoration: BoxDecoration(
              color: appTheme.blackCustom,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: TextStyleHelper.instance.title16SemiBold.copyWith(
                color: appTheme.whiteCustom,
                fontSize: 14.fSize,
              ),
            ),
          ),
          SizedBox(width: 12.h),
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