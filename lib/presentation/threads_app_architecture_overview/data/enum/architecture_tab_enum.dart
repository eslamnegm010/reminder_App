// /home/ubuntu/app/eslam_s_application/lib/presentation/threads_app_architecture_overview/data/enum/architecture_tab_enum.dart

enum ArchitectureTab {
  overview,
  stateManagement,
  implementationExamples
}

extension ArchitectureTabExtension on ArchitectureTab {
  String get name {
    switch (this) {
      case ArchitectureTab.overview:
        return 'Architecture Overview';
      case ArchitectureTab.stateManagement:
        return 'State Management';
      case ArchitectureTab.implementationExamples:
        return 'Implementation Examples';
    }
  }
}
