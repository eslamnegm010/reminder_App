// /home/ubuntu/app/eslam_s_application/lib/presentation/mark_zuckerberg_threads_profile_page/data/models/profile_model.dart

class ProfileModel {
  final String name;
  final String username;
  final String website;
  final String profilePicture;
  final String followersCount;
  final List<String> followersImages;
  final bool isFollowing;

  ProfileModel({
    required this.name,
    required this.username,
    required this.website,
    required this.profilePicture,
    required this.followersCount,
    required this.followersImages,
    this.isFollowing = false,
  });
}
