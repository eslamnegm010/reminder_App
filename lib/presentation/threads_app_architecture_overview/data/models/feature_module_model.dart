import './feature_component_model.dart';

// /home/ubuntu/app/eslam_s_application/lib/presentation/threads_app_architecture_overview/data/models/feature_module_model.dart



class FeatureModuleModel {
  final String id;
  final String name;
  final String description;
  final List<FeatureComponentModel> components;
  final bool isExpanded;

  FeatureModuleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.components,
    this.isExpanded = false,
  });

  FeatureModuleModel copyWith({
    String? id,
    String? name,
    String? description,
    List<FeatureComponentModel>? components,
    bool? isExpanded,
  }) {
    return FeatureModuleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      components: components ?? this.components,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}