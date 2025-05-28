// /home/ubuntu/app/eslam_s_application/lib/presentation/mark_zuckerberg_threads_profile_page/data/models/thread_post_model.dart

class ThreadPostModel {
  final String profileImage;
  final String username;
  final bool isVerified;
  final String timeAgo;
  final String content;
  final String repliesCount;
  final String likesCount;
  final double threadHeight;

  ThreadPostModel({
    required this.profileImage,
    required this.username,
    required this.isVerified,
    required this.timeAgo,
    required this.content,
    required this.repliesCount,
    required this.likesCount,
    required this.threadHeight,
  });
}
