import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

import '../core/i18n.dart';
import '../core/map_style.dart';
import '../core/theme.dart';
import '../data/app_data.dart';
import '../data/mock_data.dart';

enum MapView { pre, post, change }

/// Google Map of the SARC study area (AOI).
///
/// The API key goes in android/app/src/main/AndroidManifest.xml
/// (com.google.android.geo.API_KEY).
///
/// The current pre/post/change shapes are illustrative sample geometry from
/// MockData. Replace them with reviewed satellite outputs when available.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  gmaps.GoogleMapController? _controller;
  gmaps.MapType _mapType = gmaps.MapType.normal;
  bool _showAoi = true;
  MapView _view = MapView.pre;

  static const Map<MapView, String> _layerDescription = {
    MapView.pre:
        'Before the flood: a narrow sample river corridor for comparison.',
    MapView.post:
        'After the flood: expanded sample water and nearby sample locations. '
            'No impacts are verified.',
    MapView.change:
        'Sample areas highlighted as changed between the two scenarios. '
            'This does not confirm flooding or damage.',
  };

  static const double _initialZoom = 13.5;

  static const _center =
      gmaps.LatLng(AppData.aoiCenterLat, AppData.aoiCenterLng);

  Set<gmaps.Polygon> _polygons() {
    final polygons = <gmaps.Polygon>{};

    if (_showAoi) {
      polygons.add(
        gmaps.Polygon(
          polygonId: const gmaps.PolygonId('aoi'),
          points: MockData.aoiPolygon,
          fillColor: SarcColors.navy.withValues(alpha: 0.06),
          strokeColor: SarcColors.navy,
          strokeWidth: 3,
          zIndex: 2,
        ),
      );
    }

    if (_view == MapView.pre || _view == MapView.post) {
      final isPreEvent = _view == MapView.pre;
      polygons.add(
        gmaps.Polygon(
          polygonId: gmaps.PolygonId(isPreEvent ? 'pre-water' : 'post-water'),
          points: isPreEvent ? MockData.preEventWater : MockData.postEventWater,
          fillColor:
              (isPreEvent ? const Color(0xFF42A5F5) : const Color(0xFF00ACC1))
                  .withValues(alpha: 0.42),
          strokeColor:
              isPreEvent ? const Color(0xFF1565C0) : const Color(0xFF00838F),
          strokeWidth: 2,
          zIndex: 1,
        ),
      );
      if (!isPreEvent) {
        polygons.addAll(
          MockData.postEventFloodZones.indexed.map(
            (entry) => gmaps.Polygon(
              polygonId: gmaps.PolygonId('post-flood-zone-${entry.$1}'),
              points: entry.$2,
              fillColor: const Color(0xFF0288D1).withValues(alpha: 0.34),
              strokeColor: const Color(0xFF01579B),
              strokeWidth: 2,
              zIndex: 2,
            ),
          ),
        );
      }
    } else {
      polygons.addAll(
        MockData.changePatches.indexed.map(
          (entry) => gmaps.Polygon(
            polygonId: gmaps.PolygonId('change-${entry.$1}'),
            points: entry.$2,
            fillColor: const Color(0xFFFF9800).withValues(alpha: 0.48),
            strokeColor: const Color(0xFFE65100),
            strokeWidth: 2,
            zIndex: 1,
          ),
        ),
      );
    }

    return polygons;
  }

  Set<gmaps.Polyline> _polylines() => {
        const gmaps.Polyline(
          polylineId: gmaps.PolylineId('sample-river'),
          points: MockData.riverLine,
          color: Color(0xFF1565C0),
          width: 3,
          zIndex: 3,
        ),
      };

  Set<gmaps.Marker> _markers() {
    if (_view == MapView.pre) return const {};

    return MockData.settlements
        .map(
          (settlement) => gmaps.Marker(
            markerId: gmaps.MarkerId(settlement.name),
            position: settlement.position,
            icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
              gmaps.BitmapDescriptor.hueRed,
            ),
            infoWindow: gmaps.InfoWindow(
              title: 'Sample location: ${settlement.name}',
              snippet: 'Illustrative marker only; no verified impact report.',
            ),
          ),
        )
        .toSet();
  }

  Color get _layerColor => switch (_view) {
        MapView.pre => const Color(0xFF42A5F5),
        MapView.post => const Color(0xFF0288D1),
        MapView.change => const Color(0xFFFF9800),
      };

  String get _layerLegend => switch (_view) {
        MapView.pre => 'Before-flood river corridor',
        MapView.post => 'Sample flood extent',
        MapView.change => 'Sample changed areas',
      };

  void _recenter() {
    _controller?.animateCamera(
      gmaps.CameraUpdate.newCameraPosition(
        const gmaps.CameraPosition(target: _center, zoom: _initialZoom),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _showLayerInfo() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Tr(
              'About this map',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: SarcColors.navy,
              ),
            ),
            const SizedBox(height: 12),
            const Tr(
              '- Dark blue outline: the SARC study area, '
              '27.1575-27.2025 N, 88.4897-88.5403 E.\n'
              '- The layers button changes the base map (default, satellite '
              'photos, hybrid, terrain). These are Google base maps, not '
              'SARC satellite analysis.\n'
              '- Before/after flood shapes and location markers are '
              'illustrative sample geometry, not processed imagery or '
              'verified impact reports.\n\n'
              'Satellite indicators do not confirm flooding or damage.',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Tr('Map'),
        actions: [
          PopupMenuButton<gmaps.MapType>(
            tooltip: 'Map style'.tr,
            icon: const Icon(Icons.layers_outlined),
            initialValue: _mapType,
            onSelected: (t) => setState(() => _mapType = t),
            itemBuilder: (_) => const [
              PopupMenuItem(value: gmaps.MapType.normal, child: Tr('Default')),
              PopupMenuItem(
                  value: gmaps.MapType.satellite, child: Tr('Satellite')),
              PopupMenuItem(value: gmaps.MapType.hybrid, child: Tr('Hybrid')),
              PopupMenuItem(value: gmaps.MapType.terrain, child: Tr('Terrain')),
            ],
          ),
          IconButton(
            tooltip: 'About this map'.tr,
            onPressed: _showLayerInfo,
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Stack(
        children: [
          gmaps.GoogleMap(
            initialCameraPosition: const gmaps.CameraPosition(
              target: _center,
              zoom: _initialZoom,
            ),
            mapType: _mapType,
            style: (SarcColors.dark &&
                    (_mapType == gmaps.MapType.normal ||
                        _mapType == gmaps.MapType.terrain))
                ? darkMapStyle
                : null,
            minMaxZoomPreference: const gmaps.MinMaxZoomPreference(9, 20),
            polygons: _polygons(),
            polylines: _polylines(),
            markers: _markers(),
            // Keeps the Google logo visible above the toggle bar.
            padding: const EdgeInsets.only(bottom: 70),
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (c) => _controller = c,
          ),
          Positioned(
            top: 8,
            left: 12,
            right: 12,
            child: Column(
              children: [
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  color: SarcColors.card,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<MapView>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(
                            value: MapView.pre,
                            label: Tr('Before flood'),
                          ),
                          ButtonSegment(
                            value: MapView.post,
                            label: Tr('After flood'),
                          ),
                          ButtonSegment(
                            value: MapView.change,
                            label: Tr('Flood change'),
                          ),
                        ],
                        selected: {_view},
                        onSelectionChanged: (s) =>
                            setState(() => _view = s.first),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  color: SarcColors.card,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                size: 18, color: SarcColors.textMuted),
                            const SizedBox(width: 8),
                            const Tr(
                              'Flood scenario - sample',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Tr(
                          _layerDescription[_view]!,
                          style: const TextStyle(fontSize: 12.5),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 14,
                          runSpacing: 6,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _layerColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Tr(
                                  _layerLegend,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16,
                                  child: Divider(
                                    color: Color(0xFF1565C0),
                                    thickness: 3,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Tr(
                                  'Sample river line',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              color: SarcColors.card,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Tr('Study area'),
                      selected: _showAoi,
                      onSelected: (v) => setState(() => _showAoi = v),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 76,
            child: FloatingActionButton.small(
              heroTag: 'recenter',
              tooltip: 'Recenter on study area'.tr,
              backgroundColor: SarcColors.card,
              foregroundColor: SarcColors.navy,
              onPressed: _recenter,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
