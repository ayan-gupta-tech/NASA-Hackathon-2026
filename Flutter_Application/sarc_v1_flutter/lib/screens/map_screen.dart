import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
/// V2: nothing to change (OpenStreetMap tiles already live).
/// V3: replace the placeholder polygons below with real outputs:
///   - OverlayImageLayer(OverlayImage(bounds, imageProvider)) for PNG overlays
///   - PolygonLayer / PolylineLayer built from GeoJSON for river/settlements
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _controller = MapController();
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

  List<Polygon> _satellitePolygons() {
    if (!_showSatellite) return const [];
    switch (_view) {
      case MapView.pre:
        return [
          Polygon(
            points: MockData.preEventWater,
            color: SarcColors.blue.withOpacity(0.45),
            borderColor: SarcColors.blue,
            borderStrokeWidth: 1,
          ),
        ];
      case MapView.post:
        return [
          Polygon(
            points: MockData.postEventWater,
            color: const Color(0xFF00897B).withOpacity(0.45),
            borderColor: const Color(0xFF00897B),
            borderStrokeWidth: 1,
          ),
        ];
      case MapView.change:
        return [
          for (final patch in MockData.changePatches)
            Polygon(
              points: patch,
              color: SarcColors.interpreted.withOpacity(0.5),
              borderColor: SarcColors.interpreted,
              borderStrokeWidth: 2,
            ),
        ];
    }
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
          IconButton(
            tooltip: 'About layers',
            onPressed: _showLayerInfo,
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _controller,
            options: MapOptions(
              initialCenter: MockData.aoiCenter,
              initialZoom: 13.5,
              minZoom: 9,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.sarc',
              ),
              PolygonLayer(polygons: _satellitePolygons()),
              if (_showAoi)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: MockData.aoiPolygon,
                      color: SarcColors.navy.withOpacity(0.05),
                      borderColor: SarcColors.navy,
                      borderStrokeWidth: 2.5,
                    ),
                  ],
                ),
              if (_showRiver)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: MockData.riverLine,
                      strokeWidth: 4,
                      color: SarcColors.blue,
                    ),
                  ],
                ),
              if (_showSettlements)
                MarkerLayer(
                  markers: [
                    for (final s in MockData.settlements)
                      Marker(
                        point: s.position,
                        width: 44,
                        height: 44,
                        child: GestureDetector(
                          onTap: () => _showSettlement(s),
                          child: Icon(
                            Icons.location_on,
                            size: 40,
                            color: s.exposure.color,
                          ),
                        ),
                      ),
                  ],
                ),
              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('OpenStreetMap contributors'),
                ],
              ),
            ],
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
              onPressed: () => _controller.move(MockData.aoiCenter, 13.5),
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
