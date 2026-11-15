import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:latlong2/latlong.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';

enum MapView { pre, post, change }

/// Map of the AOI with the river corridor, settlements and PLACEHOLDER
/// satellite layers.
///
/// Uses Google Maps (google_maps_flutter). The API key goes in
/// android/app/src/main/AndroidManifest.xml (com.google.android.geo.API_KEY).
/// V3: replace the placeholder polygons below with real outputs:
///   - GroundOverlay (PNG + bounds) for satellite image overlays
///   - Polygon / Polyline objects built from GeoJSON for river/settlements
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  gmaps.GoogleMapController? _controller;
  gmaps.MapType _mapType = gmaps.MapType.normal;
  MapView _view = MapView.pre;
  bool _showAoi = true;
  bool _showRiver = true;
  bool _showSettlements = true;
  bool _showSatellite = true;

  static const _viewInfo = {
    MapView.pre: 'Pre-event placeholder: narrow river band. V3 will show the '
        'real Sentinel-1 scene (candidate: 28 Sep 2023).',
    MapView.post: 'Post-event placeholder: wider river band. V3 will show the '
        'real Sentinel-1 scene (candidate: 7 Oct 2023).',
    MapView.change: 'Change placeholder: orange patches mark where the demo '
        'layers differ. V3 will show the real change indicator. A change '
        'indicator is not a confirmed flood.',
  };

  static gmaps.LatLng _g(LatLng p) => gmaps.LatLng(p.latitude, p.longitude);
  static List<gmaps.LatLng> _gl(List<LatLng> l) => l.map(_g).toList();

  static const double _initialZoom = 13.5;

  Set<gmaps.Polygon> _polygons() {
    final result = <gmaps.Polygon>{};

    if (_showSatellite) {
      switch (_view) {
        case MapView.pre:
          result.add(gmaps.Polygon(
            polygonId: const gmaps.PolygonId('pre'),
            points: _gl(MockData.preEventWater),
            fillColor: SarcColors.blue.withOpacity(0.45),
            strokeColor: SarcColors.blue,
            strokeWidth: 1,
            zIndex: 1,
          ));
          break;
        case MapView.post:
          const teal = Color(0xFF00897B);
          result.add(gmaps.Polygon(
            polygonId: const gmaps.PolygonId('post'),
            points: _gl(MockData.postEventWater),
            fillColor: teal.withOpacity(0.45),
            strokeColor: teal,
            strokeWidth: 1,
            zIndex: 1,
          ));
          break;
        case MapView.change:
          var i = 0;
          for (final patch in MockData.changePatches) {
            result.add(gmaps.Polygon(
              polygonId: gmaps.PolygonId('change_${i++}'),
              points: _gl(patch),
              fillColor: SarcColors.interpreted.withOpacity(0.5),
              strokeColor: SarcColors.interpreted,
              strokeWidth: 2,
              zIndex: 1,
            ));
          }
          break;
      }
    }

    if (_showAoi) {
      result.add(gmaps.Polygon(
        polygonId: const gmaps.PolygonId('aoi'),
        points: _gl(MockData.aoiPolygon),
        fillColor: SarcColors.navy.withOpacity(0.05),
        strokeColor: SarcColors.navy,
        strokeWidth: 3,
        zIndex: 2,
      ));
    }
    return result;
  }

  Set<gmaps.Polyline> _polylines() {
    if (!_showRiver) return const {};
    return {
      gmaps.Polyline(
        polylineId: const gmaps.PolylineId('river'),
        points: _gl(MockData.riverLine),
        width: 4,
        color: SarcColors.blue,
        zIndex: 3,
      ),
    };
  }

  Set<gmaps.Marker> _markers() {
    if (!_showSettlements) return const {};
    return {
      for (final s in MockData.settlements)
        gmaps.Marker(
          markerId: gmaps.MarkerId(s.name),
          position: _g(s.position),
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
            HSVColor.fromColor(s.exposure.color).hue,
          ),
          onTap: () => _showSettlement(s),
        ),
    };
  }

  void _recenter() {
    _controller?.animateCamera(
      gmaps.CameraUpdate.newCameraPosition(
        gmaps.CameraPosition(
          target: _g(MockData.aoiCenter),
          zoom: _initialZoom,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _showSettlement(Settlement s) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: SarcColors.navy,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const LevelBadge(InfoLevel.interpretedExposure),
                const SizedBox(width: 10),
                Text(
                  '${s.exposure.label} (sample)',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: s.exposure.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(s.note, style: const TextStyle(height: 1.4)),
            const SizedBox(height: 10),
            const Text(
              'Potential exposure is an interpretation, not a prediction and '
              'not an official warning.',
              style: TextStyle(fontSize: 12.5, color: SarcColors.textMuted),
            ),
          ],
        ),
      ),
    );
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
          children: const [
            Text(
              'About these map layers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: SarcColors.navy,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '- Dark blue box: the study area (AOI), '
              '27.1575-27.2025 N, 88.4897-88.5403 E.\n'
              '- Blue line: illustrative river course (not surveyed).\n'
              '- Coloured pins: settlements with sample "potential exposure".\n'
              '- Satellite layer: placeholder shapes in V1. Real Sentinel-1 / '
              'NISAR outputs arrive in V3.\n\n'
              'Satellite layers show what a sensor observed. They do not '
              'confirm flooding or damage.',
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
        title: const Text('Map'),
        actions: [
          PopupMenuButton<gmaps.MapType>(
            tooltip: 'Map style',
            icon: const Icon(Icons.layers_outlined),
            initialValue: _mapType,
            onSelected: (t) => setState(() => _mapType = t),
            itemBuilder: (_) => const [
              PopupMenuItem(value: gmaps.MapType.normal, child: Text('Default')),
              PopupMenuItem(
                  value: gmaps.MapType.satellite, child: Text('Satellite')),
              PopupMenuItem(value: gmaps.MapType.hybrid, child: Text('Hybrid')),
              PopupMenuItem(value: gmaps.MapType.terrain, child: Text('Terrain')),
            ],
          ),
          IconButton(
            tooltip: 'About layers',
            onPressed: _showLayerInfo,
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Stack(
        children: [
          gmaps.GoogleMap(
            initialCameraPosition: gmaps.CameraPosition(
              target: _g(MockData.aoiCenter),
              zoom: _initialZoom,
            ),
            mapType: _mapType,
            minMaxZoomPreference: const gmaps.MinMaxZoomPreference(9, 20),
            polygons: _polygons(),
            polylines: _polylines(),
            markers: _markers(),
            // Keeps the Google logo visible above the layer toggle bar.
            padding: const EdgeInsets.only(bottom: 70),
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (c) => _controller = c,
          ),
          // Top controls
          Positioned(
            top: 8,
            left: 12,
            right: 12,
            child: Column(
              children: [
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<MapView>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(
                            value: MapView.pre,
                            label: Text('Pre-event'),
                          ),
                          ButtonSegment(
                            value: MapView.post,
                            label: Text('Post-event'),
                          ),
                          ButtonSegment(
                            value: MapView.change,
                            label: Text('Change'),
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4DC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFF0C36A)),
                  ),
                  child: Text(
                    'DEMO LAYERS - ${_viewInfo[_view]}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF6B4500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Layer toggles
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _toggle('Satellite', _showSatellite,
                          (v) => setState(() => _showSatellite = v)),
                      _toggle('AOI', _showAoi,
                          (v) => setState(() => _showAoi = v)),
                      _toggle('River', _showRiver,
                          (v) => setState(() => _showRiver = v)),
                      _toggle('Settlements', _showSettlements,
                          (v) => setState(() => _showSettlements = v)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 76,
            child: FloatingActionButton.small(
              heroTag: 'recenter',
              tooltip: 'Recenter on study area',
              backgroundColor: Colors.white,
              foregroundColor: SarcColors.navy,
              onPressed: _recenter,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label),
        selected: value,
        onSelected: onChanged,
      ),
    );
  }
}
