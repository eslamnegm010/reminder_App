import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/enum/threads_tab_enum.dart';
import '../data/repository/profile_repository.dart';
import './profile_state.dart';
import 'profile_state.dart';

// /home/ubuntu/app/eslam_s_application/lib/presentation/mark_zuckerberg_threads_profile_page/bloc/profile_cubit.dart







class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit(this._repository) : super(ProfileState());

  Future<void> loadProfileData() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    
    try {
      final profile = await _repository.getProfileData();
      final threads = await _repository.getThreadPosts();
      
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
        threads: threads,
        isFollowing: profile.isFollowing,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to load profile data: ${e.toString()}',
      ));
    }
  }

  Future<void> loadTabContent(ThreadsTab tab) async {
    emit(state.copyWith(selectedTab: tab));
    
    if (tab == ThreadsTab.threads && state.threads == null) {
      try {
        final threads = await _repository.getThreadPosts();
        emit(state.copyWith(threads: threads));
      } catch (e) {
        emit(state.copyWith(
          status: ProfileStatus.error,
          errorMessage: 'Failed to load threads: ${e.toString()}',
        ));
      }
    } else if (tab == ThreadsTab.replies && state.replies == null) {
      try {
        final replies = await _repository.getReplies();
        emit(state.copyWith(replies: replies));
      } catch (e) {
        emit(state.copyWith(
          status: ProfileStatus.error,
          errorMessage: 'Failed to load replies: ${e.toString()}',
        ));
      }
    }
  }

  void toggleFollow() {
    emit(state.copyWith(isFollowing: !state.isFollowing));
  }
}