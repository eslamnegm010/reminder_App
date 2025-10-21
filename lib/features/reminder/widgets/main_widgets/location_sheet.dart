import 'package:eslam_s_application/core/location_services/location_manger.dart';
import 'package:eslam_s_application/core/location_services/models/location_model.dart';
import 'package:eslam_s_application/core/location_services/location_search_service.dart';
import 'package:eslam_s_application/sheared_widgets/others/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timezone/timezone.dart';
import '../../../../core/utils/app_export.dart';

const initialEgyptLocation = LatLng(30.0444, 31.2357);

class LocationSelectionSheet extends StatefulWidget {
  final LatLng? initialLocation;

  const LocationSelectionSheet({Key? key, this.initialLocation}) : super(key: key);

  @override
  State<LocationSelectionSheet> createState() => _LocationSelectionSheetState();
}

class _LocationSelectionSheetState extends State<LocationSelectionSheet> with SingleTickerProviderStateMixin {
  LatLng? _pickedLocation;
  late TextEditingController _searchController;
  late MapController _mapController;
  late AnimationController _animController;

  List<LocationSearchResult> _suggestions = [];
  bool _isSearching = false;
  String _selectedMapType = 'standard';
  double _currentZoom = 13.0;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation;
    _searchController = TextEditingController();
    _mapController = MapController();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, spreadRadius: 5)],
          ),
          child: Column(
            children: [
              _buildDragHandle(isDark),
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildSearchBar(context, isDark),
              if (_isSearching) _buildLoadingIndicator(),
              if (_suggestions.isNotEmpty) _buildSuggestionsList(context),
              const SizedBox(height: 12),
              _buildMapControls(context),
              const SizedBox(height: 12),
              Expanded(child: _buildMap(context)),
              _buildBottomActions(context, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle(bool isDark) => Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 50,
      height: 5,
      decoration: BoxDecoration(
          color: isDark ? Colors.white24 : Colors.grey.shade300, borderRadius: BorderRadius.circular(10)));

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [AppColors.blueColor.withOpacity(0.2), AppColors.blueColor.withOpacity(0.1)]),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.map_outlined, color: AppColors.blueColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TitleText(
                  text: 'select_location',
                  subtractedSize: 8,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blueTextColor(context)),
              const SizedBox(height: 2),
              TitleText(
                text: 'tap_map_or_search',
                subtractedSize: 13,
                color: AppColors.getGrayTextColor(context),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.blueColor.withOpacity(0.2))),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'search_location'.tr(),
            hintStyle: TextStyle(color: AppColors.getGrayTextColor(context)),
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.blueColor),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.getGrayTextColor(context)),
                    onPressed: _clearSearch)
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onChanged: _onSearchChanged,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _performSearch(),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: LinearProgressIndicator(
        minHeight: 3,
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation(AppColors.blueColor),
      ),
    );
  }

  Widget _buildSuggestionsList(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      constraints: const BoxConstraints(maxHeight: 220),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.blueColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(color: AppColors.blueColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
          ]),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) => Divider(color: AppColors.getGrayTextColor(context).withOpacity(0.1), height: 1),
        itemBuilder: (ctx, i) => _buildSuggestionTile(ctx, _suggestions[i]),
      ),
    );
  }

  Widget _buildSuggestionTile(BuildContext context, LocationSearchResult result) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.blueColor.withOpacity(0.12), shape: BoxShape.circle),
          child: Icon(Icons.location_on_outlined, color: AppColors.blueColor, size: 20)),
      title: Text(result.displayName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.getTextColor(context))),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.blueColor),
      onTap: () => _selectSuggestion(result),
    );
  }

  Widget _buildMapControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        _buildMapTypeChip('standard', 'standard', Icons.map_outlined),
        const SizedBox(width: 8),
        _buildMapTypeChip('satellite', 'satellite', Icons.satellite_alt_outlined),
        const Spacer(),
        _buildZoomControls(),
      ]),
    );
  }

  Widget _buildMapTypeChip(String type, String label, IconData icon) {
    final isSelected = _selectedMapType == type;
    return InkWell(
      onTap: () => setState(() => _selectedMapType = type),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: isSelected ? AppColors.blueColor : AppColors.blueColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.blueColor.withOpacity(isSelected ? 1.0 : 0.3))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.blueColor),
          const SizedBox(width: 6),
          TitleText(
            text: label,
            subtractedSize: 12,
            color: isSelected ? Colors.white : AppColors.blueColor,
            fontWeight: FontWeight.w600,
          )
        ]),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Row(children: [
      _buildZoomButton(Icons.remove_rounded, _zoomOut),
      const SizedBox(width: 8),
      _buildZoomButton(Icons.add_rounded, _zoomIn),
      const SizedBox(width: 8),
      _buildZoomButton(Icons.my_location_rounded, _centerOnLocation),
      const SizedBox(width: 8), // TODO need to test
    ]);
  }

  // Widget _buildSaveButton(BuildContext context) => ElevatedButton.icon(
  //       icon: Icon(Icons.bookmark_add_rounded),
  //       label: Text('Save this location'),
  //       onPressed: () async {
  //         final currentLoc = currentLatLng;
  //         final address = await LocationSearchService.reverseGeocode(currentLoc);
  //         final newSaved = SavedLocation(
  //           id: DateTime.now().millisecondsSinceEpoch.toString(),
  //           name: 'Custom Location',
  //           coordinates: currentLoc,
  //           address: address,
  //           type: LocationType.other,
  //         );
  //         await LocationManager.saveLocation(newSaved);
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Location saved successfully')),
  //         );
  //       },
  //     );

  Widget _buildZoomButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: AppColors.blueColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.blueColor.withOpacity(0.3))),
          child: Icon(icon, size: 20, color: AppColors.blueColor)),
    );
  }

  Widget _buildMap(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
                initialCenter: _pickedLocation ?? initialEgyptLocation,
                initialZoom: _currentZoom,
                onTap: (tapPos, latlng) => _onMapTapped(latlng),
                onPositionChanged: (position, hasGesture) {
                  if (hasGesture
                      //  && position.zoom != null
                      ) setState(() => _currentZoom = position.zoom);
                }),
            children: [
              TileLayer(urlTemplate: _getMapTileUrl(), userAgentPackageName: 'com.reminder.en'),
              if (_pickedLocation != null) _buildMarkerLayer(),
            ],
          ),
          if (_pickedLocation != null) _buildLocationInfo(context),
        ]),
      ),
    );
  }

  String _getMapTileUrl() {
    // TODO TO Change with free map api
    return _selectedMapType == 'satellite'
        ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  }

  Widget _buildMarkerLayer() {
    return MarkerLayer(markers: [
      Marker(
          point: _pickedLocation!,
          width: 50,
          height: 50,
          child: AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(Icons.location_on_rounded,
                  color: AppColors.redColor,
                  size: 50,
                  shadows: [Shadow(color: AppColors.redColor.withOpacity(0.4), blurRadius: 8)]))),
    ]);
  }

  Widget _buildLocationInfo(BuildContext context) {
    return Positioned(
      top: 12,
      left: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]),
        child: Row(children: [
          Icon(Icons.pin_drop_rounded, color: AppColors.blueColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('selected_coordinates'.tr(),
                style: TextStyle(fontSize: 11, color: AppColors.getGrayTextColor(context))),
            Text('${_pickedLocation!.latitude.toStringAsFixed(6)}, ${_pickedLocation!.longitude.toStringAsFixed(6)}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.blueColor))
          ])),
        ]),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, bool isDark) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(children: [
          Expanded(
              child: _buildActionButton(
                  label: 'cancel'.tr(),
                  icon: Icons.close_rounded,
                  backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
                  textColor: AppColors.getTextColor(context),
                  onPressed: () => Navigator.pop(context))),
          const SizedBox(width: 12),
          Expanded(
              child: _buildActionButton(
                  label: 'confirm'.tr(),
                  icon: Icons.check_rounded,
                  backgroundColor: AppColors.blueColor,
                  textColor: Colors.white,
                  onPressed: _pickedLocation != null ? () => Navigator.pop(context, _pickedLocation) : null)),
        ]),
      ),
    );
  }

  Widget _buildActionButton(
      {required String label,
      required IconData icon,
      required Color backgroundColor,
      required Color textColor,
      VoidCallback? onPressed}) {
    return ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0),
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)));
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _suggestions = [];
    });
  }

  void _onSearchChanged(String value) {
    if (value.isEmpty) setState(() => _suggestions = []);
  }

  Future<void> _performSearch() async {
    if (_searchController.text.trim().isEmpty) return;

    setState(() => _isSearching = true);
    try {
      final results = await LocationSearchService.search(_searchController.text);
      setState(() {
        _suggestions = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
    }
  }

  void _selectSuggestion(LocationSearchResult result) {
    setState(() {
      _pickedLocation = result.location;
      _suggestions = [];
      _searchController.text = result.displayName;
    });
    _mapController.move(result.location, 15);
  }

  void _onMapTapped(LatLng location) {
    setState(() => _pickedLocation = location);
  }

  void _zoomIn() {
    final newZoom = (_currentZoom + 1).clamp(1.0, 18.0);
    setState(() => _currentZoom = newZoom);
    final center = _pickedLocation ?? initialEgyptLocation;
    _mapController.move(center, newZoom);
  }

  void _zoomOut() {
    final newZoom = (_currentZoom - 1).clamp(1.0, 18.0);
    setState(() => _currentZoom = newZoom);
    final center = _pickedLocation ?? initialEgyptLocation;
    _mapController.move(center, newZoom);
  }

  void _centerOnLocation() {
    if (_pickedLocation != null) {
      _mapController.move(_pickedLocation!, _currentZoom);
    }
  }

  Future<void> saveLocation(LatLng coordinates) async {
    final address = await LocationSearchService.reverseGeocode(coordinates);
    final newSaved = SavedLocation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Custom Location',
      coordinates: coordinates,
      address: address,
      type: LocationType.other,
      createdAt: DateTime.now(),
    );
    await LocationManager.saveLocation(newSaved);
    showSnackbar(context, message: 'Location saved successfully');
  }
}
// Move the map to the selected location with the current zoom level
