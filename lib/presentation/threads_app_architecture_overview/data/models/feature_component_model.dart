// /home/ubuntu/app/eslam_s_application/lib/presentation/threads_app_architecture_overview/data/models/feature_component_model.dart


import '../enum/component_type_enum.dart';

class FeatureComponentModel {
  final String id;
  final String name;
  final ComponentType type;
  final String description;
  final String? codeExample;
  final List<String>? dependencies;
  final bool isExpanded;

  FeatureComponentModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.codeExample,
    this.dependencies,
    this.isExpanded = false,
  });

  FeatureComponentModel copyWith({
    String? id,
    String? name,
    ComponentType? type,
    String? description,
    String? codeExample,
    List<String>? dependencies,
    bool? isExpanded,
  }) {
    return FeatureComponentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      codeExample: codeExample ?? this.codeExample,
      dependencies: dependencies ?? this.dependencies,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
