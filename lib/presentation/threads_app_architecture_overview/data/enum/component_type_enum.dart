// /home/ubuntu/app/eslam_s_application/lib/presentation/threads_app_architecture_overview/data/enum/component_type_enum.dart

import 'package:flutter/material.dart';

enum ComponentType {
  dataSource,
  enum_,
  models,
  repository,
  bloc,
  pages,
  widgets
}

extension ComponentTypeExtension on ComponentType {
  String get name {
    switch (this) {
      case ComponentType.dataSource:
        return 'Data Source';
      case ComponentType.enum_:
        return 'Enum';
      case ComponentType.models:
        return 'Models';
      case ComponentType.repository:
        return 'Repository';
      case ComponentType.bloc:
        return 'Bloc/Cubit';
      case ComponentType.pages:
        return 'Pages';
      case ComponentType.widgets:
        return 'Widgets';
    }
  }
  
  String get description {
    switch (this) {
      case ComponentType.dataSource:
        return 'Contains API calls, local storage access, etc.';
      case ComponentType.enum_:
        return 'For storing enums related to this feature.';
      case ComponentType.models:
        return 'All request/response models and local entities.';
      case ComponentType.repository:
        return 'Connects data sources to the domain layer.';
      case ComponentType.bloc:
        return 'For managing state using Bloc or Cubit.';
      case ComponentType.pages:
        return 'UI screens or views.';
      case ComponentType.widgets:
        return 'Reusable UI components related to this feature.';
    }
  }
  
  String get folder {
    switch (this) {
      case ComponentType.dataSource:
        return 'data_source';
      case ComponentType.enum_:
        return 'enum';
      case ComponentType.models:
        return 'models';
      case ComponentType.repository:
        return 'repository';
      case ComponentType.bloc:
        return 'bloc';
      case ComponentType.pages:
        return 'pages';
      case ComponentType.widgets:
        return 'widgets';
    }
  }
  
  bool get isDataLayer {
    return this == ComponentType.dataSource ||
        this == ComponentType.enum_ ||
        this == ComponentType.models ||
        this == ComponentType.repository;
  }
  
  bool get isPresentationLayer {
    return this == ComponentType.bloc ||
        this == ComponentType.pages ||
        this == ComponentType.widgets;
  }
  
  Color get color {
    switch (this) {
      case ComponentType.dataSource:
        return Color(0xFF6200EA); // Deep Purple
      case ComponentType.enum_:
        return Color(0xFF0091EA); // Light Blue
      case ComponentType.models:
        return Color(0xFF00B0FF); // Light Blue variant
      case ComponentType.repository:
        return Color(0xFF2962FF); // Blue
      case ComponentType.bloc:
        return Color(0xFFFF6D00); // Orange
      case ComponentType.pages:
        return Color(0xFF00C853); // Green
      case ComponentType.widgets:
        return Color(0xFF64DD17); // Light Green
    }
  }
}