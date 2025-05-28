// /home/ubuntu/app/eslam_s_application/lib/presentation/mark_zuckerberg_threads_profile_page/data/repository/profile_repository.dart

import '../data_source/profile_data_source.dart';
import '../models/profile_model.dart';
import '../models/thread_post_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfileData();
  Future<List<ThreadPostModel>> getThreadPosts();
  Future<List<ThreadPostModel>> getReplies();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<ProfileModel> getProfileData() async {
    return await _dataSource.getProfileData();
  }

  @override
  Future<List<ThreadPostModel>> getThreadPosts() async {
    return await _dataSource.getThreadPosts();
  }

  @override
  Future<List<ThreadPostModel>> getReplies() async {
    return await _dataSource.getReplies();
  }
}
