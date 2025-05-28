// /home/ubuntu/app/eslam_s_application/lib/presentation/threads_app_architecture_overview/bloc/architecture_state.dart

import 'package:flutter/foundation.dart';

import '../data/enum/architecture_tab_enum.dart';
import '../data/models/feature_module_model.dart';

enum ArchitectureStatus {
  initial,
  loading,
  loaded,
  error
}

extension ArchitectureStatusX on ArchitectureStatus {
  bool get isInitial => this == ArchitectureStatus.initial;
  bool get isLoading => this == ArchitectureStatus.loading;
  bool get isLoaded => this == ArchitectureStatus.loaded;
  bool get isError => this == ArchitectureStatus.error;
}

@immutable
class ArchitectureState {
  final ArchitectureStatus status;
  final List<FeatureModuleModel>? featureModules;
  final String? stateManagementExample;
  final String? implementationExample;
  final String? errorMessage;
  final ArchitectureTab selectedTab;
  final String? searchQuery;

  const ArchitectureState({
    this.status = ArchitectureStatus.initial,
    this.featureModules,
    this.stateManagementExample,
    this.implementationExample,
    this.errorMessage,
    this.selectedTab = ArchitectureTab.overview,
    this.searchQuery,
  });

  ArchitectureState copyWith({
    ArchitectureStatus? status,
    List<FeatureModuleModel>? featureModules,
    String? stateManagementExample,
    String? implementationExample,
    String? errorMessage,
    ArchitectureTab? selectedTab,
    String? searchQuery,
  }) {
    return ArchitectureState(
      status: status ?? this.status,
      featureModules: featureModules ?? this.featureModules,
      stateManagementExample: stateManagementExample ?? this.stateManagementExample,
      implementationExample: implementationExample ?? this.implementationExample,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<FeatureModuleModel>? get filteredFeatureModules {
    if (featureModules == null || searchQuery == null || searchQuery!.isEmpty) {
      return featureModules;
    }

    final query = searchQuery!.toLowerCase();
    return featureModules!.where((module) {
      // Search in module name and description
      if (module.name.toLowerCase().contains(query) ||
          module.description.toLowerCase().contains(query)) {
        return true;
      }

      // Search in component names and descriptions
      return module.components.any((component) {
        return component.name.toLowerCase().contains(query) ||
            component.description.toLowerCase().contains(query);
      });
    }).toList();
  }
}
