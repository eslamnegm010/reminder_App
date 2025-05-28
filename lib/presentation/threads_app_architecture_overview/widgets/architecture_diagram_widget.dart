import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../data/enum/component_type_enum.dart';
import '../data/models/feature_component_model.dart';
import '../data/models/feature_module_model.dart';

// /home/ubuntu/app/eslam_s_application/lib/presentation/threads_app_architecture_overview/widgets/architecture_diagram_widget.dart








class ArchitectureDiagramWidget extends StatelessWidget {
  final List<FeatureModuleModel> featureModules;
  final Function(String) onModuleToggle;
  final Function(String, String) onComponentToggle;

  const ArchitectureDiagramWidget({
    Key? key,
    required this.featureModules,
    required this.onModuleToggle,
    required this.onComponentToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLegend(),
        SizedBox(height: 24.h),
        _buildDataFlowDiagram(),
        SizedBox(height: 24.h),
        _buildFeatureModules(context),
      ],
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(8.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(26),
            blurRadius: 4.h,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Component Legend',
            style: TextStyleHelper.instance.title18Bold.copyWith(
              color: appTheme.blackCustom,
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 16.h,
            runSpacing: 12.h,
            children: ComponentType.values.map((type) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16.h,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: type.color,
                      borderRadius: BorderRadius.circular(4.h),
                    ),
                  ),
                  SizedBox(width: 8.h),
                  Text(
                    type.name,
                    style: TextStyleHelper.instance.body14Regular.copyWith(
                      color: appTheme.blackCustom,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDataFlowDiagram() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(8.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(26),
            blurRadius: 4.h,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Data Flow',
            style: TextStyleHelper.instance.title18Bold.copyWith(
              color: appTheme.blackCustom,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFlowComponent('Data Source', ComponentType.dataSource.color),
              _buildFlowArrow(),
              _buildFlowComponent('Repository', ComponentType.repository.color),
              _buildFlowArrow(),
              _buildFlowComponent('Cubit/Bloc', ComponentType.bloc.color),
              _buildFlowArrow(),
              _buildFlowComponent('UI (Pages/Widgets)', ComponentType.pages.color),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'API data must go through Data Source → Repository → Bloc → UI',
            style: TextStyleHelper.instance.body14Regular.copyWith(
              color: appTheme.blackCustom,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFlowComponent(String name, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withAlpha(51),
        border: Border.all(color: color, width: 1.h),
        borderRadius: BorderRadius.circular(4.h),
      ),
      child: Text(
        name,
        style: TextStyleHelper.instance.body14Regular.copyWith(
          color: appTheme.blackCustom,
        ),
      ),
    );
  }

  Widget _buildFlowArrow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Icon(
        Icons.arrow_forward,
        size: 20.h,
        color: appTheme.blackCustom,
      ),
    );
  }

  Widget _buildFeatureModules(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: featureModules.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final module = featureModules[index];
        return _buildFeatureModuleCard(context, module);
      },
    );
  }

  Widget _buildFeatureModuleCard(BuildContext context, FeatureModuleModel module) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(8.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(26),
            blurRadius: 4.h,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => onModuleToggle(module.id),
            child: Padding(
              padding: EdgeInsets.all(16.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module.name,
                          style: TextStyleHelper.instance.title18Bold.copyWith(
                            color: appTheme.blackCustom,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          module.description,
                          style: TextStyleHelper.instance.body14Regular.copyWith(
                            color: appTheme.blackCustom,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    module.isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: appTheme.blackCustom,
                  ),
                ],
              ),
            ),
          ),
          if (module.isExpanded) _buildModuleDetails(context, module),
        ],
      ),
    );
  }

  Widget _buildModuleDetails(BuildContext context, FeatureModuleModel module) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: appTheme.colorFFD9D9),
          SizedBox(height: 8.h),
          Text(
            'Data Layer',
            style: TextStyleHelper.instance.title16SemiBold.copyWith(
              color: appTheme.blackCustom,
            ),
          ),
          SizedBox(height: 8.h),
          _buildComponentsList(
            context,
            module,
            module.components.where((c) => c.type.isDataLayer).toList(),
          ),
          SizedBox(height: 16.h),
          Text(
            'Presentation Layer',
            style: TextStyleHelper.instance.title16SemiBold.copyWith(
              color: appTheme.blackCustom,
            ),
          ),
          SizedBox(height: 8.h),
          _buildComponentsList(
            context,
            module,
            module.components.where((c) => c.type.isPresentationLayer).toList(),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildComponentsList(
    BuildContext context,
    FeatureModuleModel module,
    List<FeatureComponentModel> components,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: components.length,
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        return _buildComponentItem(context, module, components[index]);
      },
    );
  }

  Widget _buildComponentItem(
    BuildContext context,
    FeatureModuleModel module,
    FeatureComponentModel component,
  ) {
    return Card(
      elevation: 0,
      color: component.type.color.withAlpha(26),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.h),
        side: BorderSide(color: component.type.color.withAlpha(77), width: 1.h),
      ),
      child: InkWell(
        onTap: () => onComponentToggle(module.id, component.id),
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.h,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: component.type.color,
                                borderRadius: BorderRadius.circular(4.h),
                              ),
                              child: Text(
                                component.type.folder,
                                style: TextStyleHelper.instance.body14Regular.copyWith(
                                  color: appTheme.whiteCustom,
                                  fontSize: 12.fSize,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.h),
                            Expanded(
                              child: Text(
                                component.name,
                                style: TextStyleHelper.instance.title16SemiBold
                                    .copyWith(
                                  color: appTheme.blackCustom,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          component.description,
                          style: TextStyleHelper.instance.body14Regular.copyWith(
                            color: appTheme.blackCustom,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (component.codeExample != null)
                    Icon(
                      component.isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: appTheme.blackCustom,
                    ),
                ],
              ),
              if (component.isExpanded && component.codeExample != null) ...[  
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.h),
                  decoration: BoxDecoration(
                    color: appTheme.blackCustom,
                    borderRadius: BorderRadius.circular(4.h),
                  ),
                  child: Text(
                    component.codeExample!,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12.fSize,
                      color: appTheme.whiteCustom,
                    ),
                  ),
                ),
              ],
              if (component.dependencies != null && component.dependencies!.isNotEmpty) ...[  
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.h,
                  runSpacing: 8.h,
                  children: component.dependencies!.map((dep) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.h,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: appTheme.blackCustom.withAlpha(26),
                        borderRadius: BorderRadius.circular(4.h),
                      ),
                      child: Text(
                        'Depends on: $dep',
                        style: TextStyleHelper.instance.body14Regular.copyWith(
                          color: appTheme.blackCustom,
                          fontSize: 12.fSize,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}