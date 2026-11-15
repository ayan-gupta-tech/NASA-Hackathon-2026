import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart';

class AboutDataScreen extends StatelessWidget {
  const AboutDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About and data')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Center(
            child: Image.asset(
              AppConst.logoFull,
              width: 200,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          const SarcCard(
            child: Text(
              'SARC is a research-driven, multi-sensor SAR and geospatial '
              'platform. It studies satellite-observed changes, analyses '
              'river-corridor and settlement exposure, and shares '
              'human-reviewed information with communities.',
              style: TextStyle(height: 1.5),
            ),
          ),
          const SectionHeader('Study area'),
          const SarcCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConst.aoiName,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: SarcColors.navy,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'North 27.2025, South 27.1575\n'
                  'West 88.4897, East 88.5403\n'
                  'WGS84 (EPSG:4326), about 5 km x 5 km',
                ),
                SizedBox(height: 8),
                Text(
                  'Candidate area: scene coverage and the exact inclusion of '
                  'river and settlements are still being verified.',
                  style: TextStyle(fontSize: 12.5, color: SarcColors.textMuted),
                ),
              ],
            ),
          ),
          const SectionHeader('Satellite data'),
          for (final a in MockData.acquisitions) ...[
            SarcCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${a.sensor} (${a.band})',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: SarcColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(a.date),
                  Text(a.details,
                      style: const TextStyle(color: SarcColors.textMuted)),
                  const SizedBox(height: 6),
                  Text(a.purpose, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(
                    a.status,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: SarcColors.interpreted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SectionHeader('Limitations'),
          const SarcCard(
            child: _Bullets([
              'SARC does not provide validated flood prediction.',
              'A satellite change indicator is not a confirmed flood or damage report.',
              'NISAR data from 2026 are later observations. They are not '
                  'imagery of the 2023 event.',
              'Sentinel-1 (C-band) and NISAR (S-band) values are not '
                  'interchangeable and must not be subtracted directly.',
              'Pixel spacing is not the same as effective spatial resolution.',
              'Satellite scenes may not cover the whole study area. Coverage is '
                  'verified per scene.',
              'SARC complements official channels. It does not replace them.',
            ]),
          ),
          const SectionHeader('Information levels'),
          const LevelLegend(),
          const SectionHeader('What works in this version'),
          const SarcCard(
            child: _Bullets([
              'Implemented in V1: all screens, sample advisories and '
                  'notification history, map with placeholder layers, safety '
                  'guide, emergency contacts, settings.',
              'Planned for V2: live advisories and push notifications '
                  '(Firebase), community reports, optional on-device location.',
              'Planned for V3: real Sentinel-1 and NISAR layers, change '
                  'indicator, confidence and acquisition details.',
            ]),
          ),
          const SectionHeader('Team'),
          const SarcCard(
            child: _Bullets([
              'Ayan: mobile app development',
              'Shrujal: analysis and outputs in Google Colab',
              'Alfaz: dataset refinement in ESA SNAP',
            ]),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              AppConst.versionLabel,
              style: TextStyle(fontSize: 12, color: SarcColors.textMuted),
            ),
          ),
          const DisclaimerFooter(),
        ],
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  final List<String> items;
  const _Bullets(this.items);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final t in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 7, right: 10),
                  child: Icon(Icons.circle, size: 6, color: SarcColors.blue),
                ),
                Expanded(child: Text(t, style: const TextStyle(height: 1.4))),
              ],
            ),
          ),
      ],
    );
  }
}
