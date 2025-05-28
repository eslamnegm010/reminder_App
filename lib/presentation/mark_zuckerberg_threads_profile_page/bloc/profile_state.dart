// /home/ubuntu/app/eslam_s_application/lib/presentation/mark_zuckerberg_threads_profile_page/bloc/profile_state.dart

import 'package:flutter/foundation.dart';

import '../data/enum/threads_tab_enum.dart';
import '../data/models/profile_model.dart';
import '../data/models/thread_post_model.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  error
}

extension ProfileStatusX on ProfileStatus {
  bool get isInitial => this == ProfileStatus.initial;
  bool get isLoading => this == ProfileStatus.loading;
  bool get isLoaded => this == ProfileStatus.loaded;
  bool get isError => this == ProfileStatus.error;
}

@immutable
class ProfileState {
  final ProfileStatus status;
  final ProfileModel? profile;
  final List<ThreadPostModel>? threads;
  final List<ThreadPostModel>? replies;
  final String? errorMessage;
  final ThreadsTab selectedTab;
  final bool isFollowing;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.threads,
    this.replies,
    this.errorMessage,
    this.selectedTab = ThreadsTab.threads,
    this.isFollowing = false,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileModel? profile,
    List<ThreadPostModel>? threads,
    List<ThreadPostModel>? replies,
    String? errorMessage,
    ThreadsTab? selectedTab,
    bool? isFollowing,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      threads: threads ?? this.threads,
      replies: replies ?? this.replies,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedTab: selectedTab ?? this.selectedTab,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
