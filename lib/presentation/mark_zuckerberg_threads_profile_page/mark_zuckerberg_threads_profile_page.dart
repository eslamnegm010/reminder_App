import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import './bloc/profile_cubit.dart';
import './bloc/profile_state.dart';
import './data/data_source/profile_data_source.dart';
import './data/enum/threads_tab_enum.dart';
import './data/repository/profile_repository.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/tab_navigation_widget.dart';
import './widgets/thread_post_widget.dart';

// /home/ubuntu/app/eslam_s_application/lib/presentation/mark_zuckerberg_threads_profile_page/mark_zuckerberg_threads_profile_page.dart
















class MarkZuckerbergThreadsProfilePage extends StatelessWidget {
  MarkZuckerbergThreadsProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        ProfileRepositoryImpl(
          ProfileDataSourceImpl(),
        ),
      )..loadProfileData(),
      child: Scaffold(
        backgroundColor: appTheme.whiteCustom,
        appBar: _buildAppBar(context),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.status == ProfileStatus.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.status == ProfileStatus.error) {
              return Center(child: Text(state.errorMessage ?? 'An error occurred'));
            } else if (state.status == ProfileStatus.loaded && state.profile != null) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ProfileHeaderWidget(
                      profile: state.profile!,
                      isFollowing: state.isFollowing,
                      onFollowPressed: () =>
                          context.read<ProfileCubit>().toggleFollow(),
                    ),
                    TabNavigationWidget(
                      selectedTab: state.selectedTab,
                      onTabSelected: (tab) =>
                          context.read<ProfileCubit>().loadTabContent(tab),
                    ),
                    _buildContentForTab(context, state),
                    SizedBox(height: 80.h),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
        bottomNavigationBar: BottomNavigationWidget(),
      ),
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

  Widget _buildContentForTab(BuildContext context, ProfileState state) {
    switch (state.selectedTab) {
      case ThreadsTab.threads:
        if (state.threads == null || state.threads!.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              child: Text('No threads available'),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: state.threads!.length,
          itemBuilder: (context, index) {
            return ThreadPostWidget(threadPost: state.threads![index]);
          },
        );
      case ThreadsTab.replies:
        if (state.replies == null || state.replies!.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              child: Text('No replies available'),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: state.replies!.length,
          itemBuilder: (context, index) {
            return ThreadPostWidget(threadPost: state.replies![index]);
          },
        );
    }
  }
}