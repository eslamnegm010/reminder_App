import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/enum/architecture_tab_enum.dart';
import '../data/models/feature_component_model.dart';
import '../data/models/feature_module_model.dart';
import '../data/repository/architecture_repository.dart';
import './architecture_state.dart';
import 'architecture_state.dart';

// /home/ubuntu/app/eslam_s_application/lib/presentation/threads_app_architecture_overview/bloc/architecture_cubit.dart









class ArchitectureCubit extends Cubit<ArchitectureState> {
  final ArchitectureRepository _repository;

  ArchitectureCubit(this._repository) : super(ArchitectureState());

  void loadData() {
    emit(state.copyWith(status: ArchitectureStatus.loading));

    try {
      final featureModules = _repository.getFeatureModules();
      final stateManagementExample = _repository.getStateManagementExample();
      final implementationExample = _repository.getImplementationExample();

      emit(state.copyWith(
        status: ArchitectureStatus.loaded,
        featureModules: featureModules,
        stateManagementExample: stateManagementExample,
        implementationExample: implementationExample,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ArchitectureStatus.error,
        errorMessage: 'Failed to load architecture data: ${e.toString()}',
      ));
    }
  }

  void selectTab(ArchitectureTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }

  void toggleModuleExpansion(String moduleId) {
    if (state.featureModules == null) return;

    final updatedModules = state.featureModules!.map((module) {
      if (module.id == moduleId) {
        return module.copyWith(isExpanded: !module.isExpanded);
      }
      return module;
    }).toList();

    emit(state.copyWith(featureModules: updatedModules));
  }

  void toggleComponentExpansion(String moduleId, String componentId) {
    if (state.featureModules == null) return;

    final updatedModules = state.featureModules!.map((module) {
      if (module.id == moduleId) {
        final updatedComponents = module.components.map((component) {
          if (component.id == componentId) {
            return component.copyWith(isExpanded: !component.isExpanded);
          }
          return component;
        }).toList();

        return module.copyWith(components: updatedComponents);
      }
      return module;
    }).toList();

    emit(state.copyWith(featureModules: updatedModules));
  }

  void updateSearchQuery(String? query) {
    emit(state.copyWith(searchQuery: query));
  }
}