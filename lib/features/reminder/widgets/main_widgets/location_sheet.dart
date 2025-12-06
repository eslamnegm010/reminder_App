import 'package:eslam_s_application/core/location_services/location_service.dart';
import 'package:eslam_s_application/core/location_services/models/location_model.dart';
import 'package:eslam_s_application/features/reminder/cubit/location_picker_cubit.dart';
import 'package:eslam_s_application/features/reminder/cubit/location_picker_state.dart';
import 'package:eslam_s_application/features/reminder/widgets/location_sheet/save_location_dialog.dart';
import 'package:eslam_s_application/sheared_widgets/default_button.dart';
import 'package:eslam_s_application/sheared_widgets/others/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_export.dart';
import '../location_sheet/location_map_controls.dart';
import '../location_sheet/location_search_bar.dart';
import '../location_sheet/location_sheet_header.dart';
import '../location_sheet/location_suggestions_list.dart';

const initialEgyptLocation = LatLng(30.0444, 31.2357);

class LocationSelectionSheet extends StatefulWidget {
  final LatLng? initialLocation;

  const LocationSelectionSheet({Key? key, this.initialLocation}) : super(key: key);

  @override
  State<LocationSelectionSheet> createState() => _LocationSelectionSheetState();
}

class _LocationSelectionSheetState extends State<LocationSelectionSheet>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationPickerCubit()..init(widget.initialLocation),
      child: Builder(builder: (context) => _buildSheetContent(context)),
    );
  }

  Widget _buildSheetContent(BuildContext context) {
    return BlocConsumer<LocationPickerCubit, LocationPickerState>(
      listener: (context, state) {
        // TODO
      },
      builder: (context, state) {
        final cubit = context.read<LocationPickerCubit>();
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return DraggableScrollableSheet(
          initialChildSize: 0.95,
          minChildSize: 0.7,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const LocationSheetHeader(),
                  const SizedBox(height: 16),
                  LocationSearchBar(
                    controller: _searchController,
                    onClear: () {
                      _searchController.clear();
                      cubit.clearSearch();
                    },
                    onChanged: (val) {
                      if (val.isEmpty) cubit.clearSearch();
                    },
                    onSubmitted: (query) => cubit.searchLocations(query),
                    isSearching: state.isSearching,
                  ),
                  if (state.searchResults.isNotEmpty)
                    LocationSuggestionsList(
                      suggestions: state.searchResults,
                      onSelect: (result) {
                        cubit.selectSuggestion(result);
                        _searchController.text = result.displayName;
                        _mapController.move(result.location, 15);
                      },
                    ),
                  const SizedBox(height: 12),
                  LocationMapControls(
                    selectedMapType: state.selectedMapType,
                    onMapTypeChanged: cubit.updateMapType,
                    onZoomIn: () => _zoomIn(cubit, state),
                    onZoomOut: () => _zoomOut(cubit, state),
                    onCenterLocation: () => _centerOnLocation(context, cubit, state),
                  ),
                  const SizedBox(height: 12),
                  Expanded(child: _buildMap(context, cubit, state)),
                  _buildBottomActions(context, cubit, state, isDark),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMap(
    BuildContext context,
    LocationPickerCubit cubit,
    LocationPickerState state,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: widget.initialLocation ?? initialEgyptLocation,
                initialZoom: state.currentZoom,
                onTap: (tapPos, latlng) => cubit.selectMapLocation(latlng),
                onPositionChanged: (position, hasGesture) {
                  if (hasGesture) {
                    cubit.updateZoom(position.zoom);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: cubit.getMapTileUrl(state.selectedMapType),
                  userAgentPackageName: cubit.userAgentPackageName,
                ),
                if (state.pickedLocation != null)
                  _buildMarkerLayer(state.pickedLocation!),
              ],
            ),
            if (state.pickedLocation != null)
              _buildLocationInfo(context, state.pickedLocation!),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkerLayer(LatLng location) {
    return MarkerLayer(
      markers: [
        Marker(
          point: location,
          width: 50,
          height: 50,
          child: AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              Icons.location_on_rounded,
              color: AppColors.redColor,
              size: 50,
              shadows: [
                Shadow(color: AppColors.redColor.withValues(alpha: 0.4), blurRadius: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo(BuildContext context, LatLng location) {
    return Positioned(
      top: 12,
      left: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.pin_drop_rounded, color: AppColors.blueColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(
                    text: 'selected_coordinates'.tr(),
                    color: AppColors.getGrayTextColor(context),
                    subtractedSize: 12,
                  ),
                  TitleText(
                    text:
                        '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}',
                    color: AppColors.blueColor,
                    subtractedSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    LocationPickerCubit cubit,
    LocationPickerState state,
    bool isDark,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: 'cancel'.tr(),
                    icon: Icons.close_rounded,
                    backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                    textColor: AppColors.getTextColor(context),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    label: 'confirm'.tr(),
                    icon: Icons.check_rounded,
                    backgroundColor: AppColors.blueColor,
                    textColor: Colors.white,
                    onPressed: state.pickedLocation != null
                        ? () {
                            String name = '';
                            if (_searchController.text.isNotEmpty) {
                              name = _searchController.text;
                            }

                            final result = LocationSearchResult(
                              displayName: name.isNotEmpty
                                  ? name
                                  : '${state.pickedLocation!.latitude.toStringAsFixed(4)}, ${state.pickedLocation!.longitude.toStringAsFixed(4)}',
                              type: 'picked',
                              location: state.pickedLocation!,
                              address: {},
                            );
                            Navigator.pop(context, result);
                          }
                        : null,
                  ),
                ),
              ],
            ),
            if (state.pickedLocation != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: _buildActionButton(
                  label: 'save_for_later',
                  icon: Icons.bookmark_border_rounded,
                  backgroundColor: AppColors.blueColor.withValues(alpha: 0.1),
                  textColor: AppColors.blueColor,
                  onPressed: () => showSaveLocationDialog(context, cubit),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    VoidCallback? onPressed,
  }) {
    return DefaultButton(
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      elevation: 0,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      labelColor: textColor,
      loadingSize: 20,
      icon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Icon(icon, size: 20.h),
      ),
      labelWidget: TitleText(
        text: label.tr().toUpperCase(),
        subtractedSize: 10,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }

  void _zoomIn(LocationPickerCubit cubit, LocationPickerState state) {
    final newZoom = (state.currentZoom + 1).clamp(1.0, 18.0);
    cubit.updateZoom(newZoom);
    final center = state.pickedLocation ?? initialEgyptLocation;
    _mapController.move(center, newZoom);
  }

  void _zoomOut(LocationPickerCubit cubit, LocationPickerState state) {
    final newZoom = (state.currentZoom - 1).clamp(1.0, 18.0);
    cubit.updateZoom(newZoom);
    final center = state.pickedLocation ?? initialEgyptLocation;
    _mapController.move(center, newZoom);
  }

  Future<void> _centerOnLocation(
    BuildContext context,
    LocationPickerCubit cubit,
    LocationPickerState state,
  ) async {
    try {
      final position = await LocationService.instance.determinePosition();
      final newLoc = LatLng(position.latitude, position.longitude);

      cubit.selectMapLocation(newLoc);
      _mapController.move(newLoc, state.currentZoom);
    } catch (e) {
      showSnackbar(context, message: 'Could not get current location: $e');
    }
  }
}
