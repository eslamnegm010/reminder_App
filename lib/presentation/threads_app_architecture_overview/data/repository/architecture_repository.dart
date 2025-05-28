// /home/ubuntu/app/eslam_s_application/lib/presentation/threads_app_architecture_overview/data/repository/architecture_repository.dart

import '../data_source/architecture_data_source.dart';
import '../models/feature_module_model.dart';

abstract class ArchitectureRepository {
  List<FeatureModuleModel> getFeatureModules();
  String getStateManagementExample();
  String getImplementationExample();
}

class ArchitectureRepositoryImpl implements ArchitectureRepository {
  final ArchitectureDataSource _dataSource;

  ArchitectureRepositoryImpl(this._dataSource);

  @override
  List<FeatureModuleModel> getFeatureModules() {
    return _dataSource.getFeatureModules();
  }

  @override
  String getStateManagementExample() {
    return _dataSource.getStateManagementExample();
  }

  @override
  String getImplementationExample() {
    return _dataSource.getImplementationExample();
  }
}
