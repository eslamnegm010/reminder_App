// /home/ubuntu/app/eslam_s_application/lib/presentation/mark_zuckerberg_threads_profile_page/data/enum/threads_tab_enum.dart

enum ThreadsTab {
  threads,
  replies
}

extension ThreadsTabExtension on ThreadsTab {
  String get name {
    switch (this) {
      case ThreadsTab.threads:
        return 'Threads';
      case ThreadsTab.replies:
        return 'Replies';
    }
  }
}
