import '../../../../core/app_export.dart';
import '../../../../core/utils/image_constant.dart';
import '../models/profile_model.dart';
import '../models/thread_post_model.dart';

// /home/ubuntu/app/eslam_s_application/lib/presentation/mark_zuckerberg_threads_profile_page/data/data_source/profile_data_source.dart





abstract class ProfileDataSource {
  Future<ProfileModel> getProfileData();
  Future<List<ThreadPostModel>> getThreadPosts();
  Future<List<ThreadPostModel>> getReplies();
}

class ProfileDataSourceImpl implements ProfileDataSource {
  @override
  Future<ProfileModel> getProfileData() async {
    // Simulating API call with a delay
    await Future.delayed(Duration(milliseconds: 500));
    
    return ProfileModel(
      name: 'Mark Zuckerberg',
      username: 'zuck',
      website: 'fb.com',
      profilePicture: ImageConstant.imgProfilePic,
      followersCount: '412k',
      followersImages: [ImageConstant.imgUsersAlreadyFollowing],
    );
  }

  @override
  Future<List<ThreadPostModel>> getThreadPosts() async {
    // Simulating API call with a delay
    await Future.delayed(Duration(milliseconds: 700));
    
    return [
      ThreadPostModel(
        profileImage: ImageConstant.imgEllipse1,
        username: 'zuck',
        isVerified: true,
        timeAgo: '33m',
        content: '10 million sign ups in seven hours.',
        repliesCount: '26',
        likesCount: '112',
        threadHeight: 48,
      ),
      ThreadPostModel(
        profileImage: ImageConstant.imgEllipse1,
        username: 'zuck',
        isVerified: true,
        timeAgo: '7h',
        content: 'Just passed 5 million sign ups in the first four hours...',
        repliesCount: '26',
        likesCount: '112',
        threadHeight: 74,
      ),
      ThreadPostModel(
        profileImage: ImageConstant.imgEllipse1,
        username: 'zuck',
        isVerified: true,
        timeAgo: '9h',
        content: 'Threads just passed 2 million sign ups in the first two hours.',
        repliesCount: '26',
        likesCount: '112',
        threadHeight: 74,
      ),
    ];
  }

  @override
  Future<List<ThreadPostModel>> getReplies() async {
    // Simulating API call with a delay
    await Future.delayed(Duration(milliseconds: 700));
    
    // Return empty list as we don't have replies in the design
    return [];
  }
}