import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_export.dart';
import './bloc/architecture_cubit.dart';
import './bloc/architecture_state.dart';
import './data/data_source/architecture_data_source.dart';
import './data/enum/architecture_tab_enum.dart';
import './data/repository/architecture_repository.dart';
import './widgets/architecture_diagram_widget.dart';
import './widgets/implementation_examples_widget.dart';
import './widgets/state_management_widget.dart';
import './widgets/tab_navigation_widget.dart';

// /home/ubuntu/app/eslam_s_application/lib/presentation/threads_app_architecture_overview/threads_app_architecture_overview.dart















class ThreadsAppArchitectureOverview extends StatelessWidget {
  ThreadsAppArchitectureOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArchitectureCubit(
        ArchitectureRepositoryImpl(
          ArchitectureDataSourceImpl(),
        ),
      )..loadData(),
      child: Scaffold(
        backgroundColor: appTheme.gray,
        appBar: _buildAppBar(context),
        body: BlocBuilder<ArchitectureCubit, ArchitectureState>(
          builder: (context, state) {
            if (state.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.error) {
              return Center(child: Text(state.errorMessage ?? 'An error occurred'));
            } else if (state.loaded) {
              return Column(
                children: [
                  _buildSearchBar(context),
                  ArchitectureTabNavigationWidget(
                    selectedTab: state.selectedTab,
                    onTabSelected: (tab) =>
                        context.read<ArchitectureCubit>().selectTab(tab),
                  ),
                  Expanded(
                    child: _buildContentForTab(context, state),
                  ),
                ],
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: appTheme.whiteCustom,
      elevation: 0,
      title: Text(
        'Threads App Architecture',
        style: TextStyleHelper.instance.title18Bold.copyWith(
          color: appTheme.blackCustom,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.h),
      color: appTheme.whiteCustom,
      child: TextField(
        onChanged: (value) {
          context.read<ArchitectureCubit>().updateSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'Search components...',
          prefixIcon: Icon(Icons.search, color: appTheme.blackCustom),
          filled: true,
          fillColor: appTheme.gray200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.h),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.h),
        ),
      ),
    );
  }

  Widget _buildContentForTab(BuildContext context, ArchitectureState state) {
    switch (state.selectedTab) {
      case ArchitectureTab.overview:
        if (state.filteredFeatureModules == null) {
          return Center(child: Text('No feature modules available'));
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.h),
          child: ArchitectureDiagramWidget(
            featureModules: state.filteredFeatureModules!,
            onModuleToggle: (moduleId) =>
                context.read<ArchitectureCubit>().toggleModuleExpansion(moduleId),
            onComponentToggle: (moduleId, componentId) => context
                .read<ArchitectureCubit>()
                .toggleComponentExpansion(moduleId, componentId),
          ),
        );
      case ArchitectureTab.stateManagement:
        if (state.stateManagementExample == null) {
          return Center(child: Text('State management example not available'));
        }
        return StateManagementWidget(
          codeExample: state.stateManagementExample!,
        );
      case ArchitectureTab.implementationExamples:
        if (state.implementationExample == null) {
          return Center(child: Text('Implementation example not available'));
        }
        return ImplementationExamplesWidget(
          codeExample: state.implementationExample!,
        );
    }
  }
}